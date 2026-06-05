const mongoose = require('mongoose');

const verificationRequestSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  collegeEmail: {
    type: String,
    required: true,
    trim: true,
    lowercase: true,
  },
  collegeName: {
    type: String,
    required: true,
    trim: true,
  },
  idImageUrl: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending',
  },
  rejectionReason: {
    type: String,
  },
  reviewedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  reviewedAt: {
    type: Date,
  },
}, {
  timestamps: true,
});

module.exports = mongoose.model('VerificationRequest', verificationRequestSchema);
