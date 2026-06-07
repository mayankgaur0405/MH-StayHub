const jwt = require('jsonwebtoken');
const User = require('../users/user.model');
const sendOtp = async (req, res) => {
  try {
    const { phone } = req.body;
    if (!phone) return res.status(400).json({ message: 'Phone number is required' });

    // Clean phone number (remove +, spaces, etc.)
    let cleanPhone = phone.replace(/\D/g, '');
    if (cleanPhone.length === 10) {
      cleanPhone = '91' + cleanPhone; // Default to India country code
    }

    // MSG91 Send OTP API
    const url = `https://control.msg91.com/api/v5/otp?template_id=${process.env.MSG91_TEMPLATE_ID}&mobile=${cleanPhone}`;
    const options = {
      method: 'POST',
      headers: {
        'authkey': process.env.MSG91_AUTH_KEY,
        'Content-Type': 'application/json'
      }
    };

    const response = await fetch(url, options);
    const data = await response.json();

    if (data.type === 'error') {
      return res.status(400).json({ message: data.message || 'Failed to send OTP', success: false });
    }

    res.status(200).json({ message: 'OTP sent successfully', success: true });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

const verifyOtp = async (req, res) => {
  try {
    const { phone, otp, name } = req.body;
    if (!phone || !otp) return res.status(400).json({ message: 'Phone and OTP required' });

    let cleanPhone = phone.replace(/\D/g, '');
    if (cleanPhone.length === 10) {
      cleanPhone = '91' + cleanPhone;
    }

    // MSG91 Verify OTP API
    const url = `https://control.msg91.com/api/v5/otp/verify?otp=${otp}&mobile=${cleanPhone}`;
    const options = {
      method: 'GET',
      headers: {
        'authkey': process.env.MSG91_AUTH_KEY
      }
    };

    const response = await fetch(url, options);
    const data = await response.json();

    if (data.type === 'error') {
      return res.status(400).json({ message: data.message || 'Invalid OTP', success: false });
    }

    let user = await User.findOne({ phone });
    if (!user) {
      user = await User.create({ phone, name: name || 'Student' });
    }

    const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET || 'fallback_secret', { expiresIn: '30d' });

    res.status(200).json({ success: true, data: { token, user } });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

const getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-__v');
    res.status(200).json({ success: true, data: user });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

const updateProfile = async (req, res) => {
  try {
    const { name, email } = req.body;
    const user = await User.findByIdAndUpdate(
      req.user._id,
      { name, email },
      { new: true, runValidators: true }
    ).select('-__v');
    res.status(200).json({ success: true, data: user });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

const getSavedAccommodations = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).populate('savedAccommodations');
    res.status(200).json({ success: true, data: user.savedAccommodations });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

const saveAccommodation = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findByIdAndUpdate(
      req.user._id,
      { $addToSet: { savedAccommodations: id } },
      { new: true }
    );
    res.status(200).json({ success: true, data: user.savedAccommodations });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

const unsaveAccommodation = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findByIdAndUpdate(
      req.user._id,
      { $pull: { savedAccommodations: id } },
      { new: true }
    );
    res.status(200).json({ success: true, data: user.savedAccommodations });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

module.exports = { 
  sendOtp, 
  verifyOtp, 
  getMe, 
  updateProfile, 
  getSavedAccommodations, 
  saveAccommodation, 
  unsaveAccommodation 
};
