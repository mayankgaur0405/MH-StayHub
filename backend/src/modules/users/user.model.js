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
  savedAccommodations: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Accommodation',
  }],
}, {
  timestamps: true,
});

module.exports = mongoose.model('User', userSchema);
