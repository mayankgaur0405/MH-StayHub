const express = require('express');
const { createOrder, verifyPayment, getHistory, webhookVerification } = require('./payment.controller');
const { protect } = require('../../middleware/auth.middleware');

const router = express.Router();

router.post('/create-order', protect, createOrder);
router.post('/verify-payment', protect, verifyPayment);
router.get('/history', protect, getHistory);

// Public webhook endpoint
router.post('/webhook', webhookVerification);

module.exports = router;
