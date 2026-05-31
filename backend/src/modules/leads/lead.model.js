const mongoose = require('mongoose');

const leadSchema = new mongoose.Schema({
  studentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  accommodation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Accommodation',
    required: true,
  },
  type: {
    type: String,
    enum: ['visit', 'token_booking'],
    default: 'visit',
  },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'cancelled', 'completed', 'pending_owner_approval'],
    default: 'pending',
  },
  source: {
    type: String,
    enum: ['web', 'app', 'referral', 'organic'],
    default: 'app',
  },
  payment: {
    amount: Number,
    transactionId: String,
    status: {
      type: String,
      enum: ['pending', 'success', 'failed', 'refunded'],
      default: 'pending',
    }
  },
  preferredDate: Date,
  notes: String,
}, {
  timestamps: true,
});

// Index for fetching user's bookings quickly
leadSchema.index({ studentId: 1, createdAt: -1 });

module.exports = mongoose.model('Lead', leadSchema);
