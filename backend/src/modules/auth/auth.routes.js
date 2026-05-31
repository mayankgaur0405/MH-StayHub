const express = require('express');
const { sendOtp, verifyOtp, getMe, updateProfile, getSavedAccommodations, saveAccommodation, unsaveAccommodation } = require('./auth.controller');
const { protect } = require('../../middleware/auth.middleware');

const router = express.Router();

router.post('/send-otp', sendOtp);
router.post('/verify-otp', verifyOtp);

router.get('/me', protect, getMe);
router.put('/update-profile', protect, updateProfile);

router.get('/saved-accommodations', protect, getSavedAccommodations);
router.post('/save-accommodation/:id', protect, saveAccommodation);
router.delete('/unsave-accommodation/:id', protect, unsaveAccommodation);

module.exports = router;
