const VerificationRequest = require('./verification.model');
const User = require('../users/user.model');
const Notification = require('../notifications/notification.model');

// @desc    Submit student verification
// @route   POST /api/v1/student-advantage/verification
// @access  Private
exports.submitVerification = async (req, res, next) => {
  try {
    const { collegeEmail, collegeName } = req.body;
    const userId = req.user.id; // Assuming auth middleware sets req.user

    // Check if user already submitted a request
    const existingRequest = await VerificationRequest.findOne({ user: userId, status: 'pending' });
    if (existingRequest) {
      return res.status(400).json({ success: false, message: 'Verification request already pending.' });
    }

    // Check if user already verified
    const user = await User.findById(userId);
    if (user.studentVerificationStatus === 'verified') {
      return res.status(400).json({ success: false, message: 'User is already verified.' });
    }

    if (!req.file) {
      return res.status(400).json({ success: false, message: 'Student ID image is required.' });
    }

    const verification = await VerificationRequest.create({
      user: userId,
      collegeEmail,
      collegeName,
      idImageUrl: req.file.path, // Cloudinary URL
    });

    user.studentVerificationStatus = 'pending';
    user.studentIdImage = req.file.path;
    user.collegeEmail = collegeEmail;
    user.collegeName = collegeName;
    await user.save();

    res.status(201).json({
      success: true,
      data: verification,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get current user verification status
// @route   GET /api/v1/student-advantage/verification/status
// @access  Private
exports.getVerificationStatus = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    
    // Also fetch the latest request for details if any
    const latestRequest = await VerificationRequest.findOne({ user: req.user.id }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: {
        status: user.studentVerificationStatus,
        tier: user.membershipTier,
        requestDetails: latestRequest,
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get student dashboard data
// @route   GET /api/v1/student-advantage/dashboard
// @access  Private
exports.getDashboardData = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    
    // In later phases, we'll fetch coupons, events, etc.
    const dashboardData = {
      user: {
        name: user.name,
        collegeName: user.collegeName,
        verificationStatus: user.studentVerificationStatus,
        membershipTier: user.membershipTier,
      },
      stats: {
        activeCoupons: 0,
        upcomingEvents: 0,
        notifications: await Notification.countDocuments({ user: req.user.id, isRead: false }),
      }
    };

    res.status(200).json({
      success: true,
      data: dashboardData,
    });
  } catch (error) {
    next(error);
  }
};
