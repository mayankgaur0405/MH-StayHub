const mongoose = require('mongoose');

const seniorQuerySchema = new mongoose.Schema({
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  content: { type: String, required: true },
  category: { type: String, enum: ['guidance', 'referral', 'academics', 'general'], required: true },
  status: { type: String, enum: ['open', 'answered', 'closed'], default: 'open' },
  replies: [{
    author: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    content: { type: String },
    createdAt: { type: Date, default: Date.now },
    isSenior: { type: Boolean, default: false }
  }]
}, { timestamps: true });

module.exports = mongoose.model('SeniorQuery', seniorQuerySchema);
