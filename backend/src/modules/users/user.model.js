const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true,
    index: true,
  },
  name: {
    type: String,
    trim: true,
  },
  email: {
    type: String,
    trim: true,
    lowercase: true,
  },
  role: {
    type: String,
    enum: ['student', 'owner', 'admin'],
    default: 'student',
  },
  collegeEmail: {
    type: String,
    trim: true,
    lowercase: true,
  },
  collegeName: {
    type: String,
    trim: true,
  },
  studentVerificationStatus: {
    type: String,
    enum: ['none', 'pending', 'verified', 'rejected'],
    default: 'none',
  },
  membershipTier: {
    type: String,
    enum: ['free', 'verified', 'premium'],
    default: 'free',
  },
  studentIdImage: {
    type: String,
  },
  savedAccommodations: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Accommodation',
  }],
}, {
  timestamps: true,
});

module.exports = mongoose.model('User', userSchema);
