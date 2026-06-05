const express = require('express');
const {
  submitVerification,
  getVerificationStatus,
  getDashboardData
} = require('./studentAdvantage.controller');
const upload = require('../../middleware/upload.middleware');
const { protect } = require('../../middleware/auth.middleware');

const router = express.Router();

router.post('/verification', protect, upload.single('studentIdImage'), submitVerification);
router.get('/verification/status', protect, getVerificationStatus);
router.get('/dashboard', protect, getDashboardData);

module.exports = router;
