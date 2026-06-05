const express = require('express');
const { getCoupons } = require('./coupon.controller');
const { protect } = require('../../middleware/auth.middleware');
const router = express.Router();

router.use(protect);
router.get('/', getCoupons);
module.exports = router;
