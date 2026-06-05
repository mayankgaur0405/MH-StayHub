const mongoose = require('mongoose');

const couponSchema = new mongoose.Schema({
  code: { type: String, required: true, unique: true },
  description: { type: String, required: true },
  partnerName: { type: String, required: true },
  discountAmount: { type: String, required: true },
  expiryDate: { type: Date, required: true },
  status: { type: String, enum: ['active', 'expired', 'disabled'], default: 'active' },
  category: { type: String, enum: ['food', 'shopping', 'education', 'lifestyle', 'other'], default: 'other' },
  minimumTier: { type: String, enum: ['free', 'verified', 'premium'], default: 'free' }
}, { timestamps: true });

module.exports = mongoose.model('Coupon', couponSchema);
