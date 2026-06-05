const Coupon = require('./coupon.model');

exports.getCoupons = async (req, res, next) => {
  try {
    const coupons = await Coupon.find({ status: 'active' });
    res.status(200).json({ success: true, count: coupons.length, data: coupons });
  } catch (error) { next(error); }
};
