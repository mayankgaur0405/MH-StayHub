const VerificationRequest = require('../studentAdvantage/verification.model');
const User = require('../users/user.model');
const Notification = require('../notifications/notification.model');

// @desc    Get all verification requests
// @route   GET /api/v1/admin/verifications
// @access  Private/Admin
exports.getVerifications = async (req, res, next) => {
  try {
    const verifications = await VerificationRequest.find()
      .populate('user', 'name email phone role')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: verifications.length,
      data: verifications,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Approve verification
// @route   PUT /api/v1/admin/verifications/:id/approve
// @access  Private/Admin
exports.approveVerification = async (req, res, next) => {
  try {
    const verification = await VerificationRequest.findById(req.params.id);

    if (!verification) {
      return res.status(404).json({ success: false, message: 'Verification request not found' });
    }

    if (verification.status !== 'pending') {
      return res.status(400).json({ success: false, message: `Request is already ${verification.status}` });
    }

    verification.status = 'approved';
    verification.reviewedBy = req.user.id;
    verification.reviewedAt = Date.now();
    await verification.save();

    // Update User
    const user = await User.findById(verification.user);
    user.studentVerificationStatus = 'verified';
    user.membershipTier = 'verified';
    await user.save();

    // Send Notification
    await Notification.create({
      user: user._id,
      title: 'Verification Approved',
      message: 'Congratulations! Your student verification has been approved. Welcome to the Student Advantage program!',
      type: 'verification',
    });

    res.status(200).json({
      success: true,
      data: verification,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Reject verification
// @route   PUT /api/v1/admin/verifications/:id/reject
// @access  Private/Admin
exports.rejectVerification = async (req, res, next) => {
  try {
    const { reason } = req.body;
    const verification = await VerificationRequest.findById(req.params.id);

    if (!verification) {
      return res.status(404).json({ success: false, message: 'Verification request not found' });
    }

    if (verification.status !== 'pending') {
      return res.status(400).json({ success: false, message: `Request is already ${verification.status}` });
    }

    verification.status = 'rejected';
    verification.rejectionReason = reason || 'Your ID could not be verified. Please try again.';
    verification.reviewedBy = req.user.id;
    verification.reviewedAt = Date.now();
    await verification.save();

    // Update User
    const user = await User.findById(verification.user);
    user.studentVerificationStatus = 'rejected';
    await user.save();

    // Send Notification
    await Notification.create({
      user: user._id,
      title: 'Verification Rejected',
      message: verification.rejectionReason,
      type: 'verification',
    });

    res.status(200).json({
      success: true,
      data: verification,
    });
  } catch (error) {
    next(error);
  }
};
