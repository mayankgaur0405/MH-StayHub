const jwt = require('jsonwebtoken');
const User = require('../users/user.model');

const MOCK_OTP = '123456';
const isMsg91Configured = Boolean(process.env.MSG91_AUTH_KEY && process.env.MSG91_TEMPLATE_ID);

const sendOtp = async (req, res) => {
  try {
    const { phone } = req.body;
    if (!phone) return res.status(400).json({ message: 'Phone number is required' });

    // MVP fallback: keep OTP login available until MSG91 credentials are added.
    if (!isMsg91Configured) {
      await new Promise(resolve => setTimeout(resolve, 300));

      return res.status(200).json({
        message: `OTP sent successfully (MVP mock mode: use ${MOCK_OTP})`,
        success: true,
        mock: true,
      });
    }

    // TODO: Integrate MSG91 here when production SMS delivery is enabled.
    // await axios.post(`msg91_url?authkey=${process.env.MSG91_AUTH_KEY}&mobiles=${phone}...`)
    
    // Simulating delay
    await new Promise(resolve => setTimeout(resolve, 500));

    res.status(200).json({ message: `OTP sent successfully (MVP mock mode: use ${MOCK_OTP})`, success: true, mock: true });
  } catch (error) {
    res.status(500).json({ message: error.message, success: false });
  }
};

const verifyOtp = async (req, res) => {
  try {
    const { phone, otp, name } = req.body;
    if (!phone || !otp) return res.status(400).json({ message: 'Phone and OTP required' });

    // MVP mock verification until MSG91 verification is enabled.
    if (otp !== MOCK_OTP) {
      return res.status(400).json({ message: 'Invalid OTP', success: false });
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
