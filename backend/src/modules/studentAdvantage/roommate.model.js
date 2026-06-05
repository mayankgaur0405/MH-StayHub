const mongoose = require('mongoose');

const roommateProfileSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  budget: { type: Number, required: true },
  college: { type: String, required: true },
  foodPreference: { type: String, enum: ['veg', 'non-veg', 'any'], required: true },
  yearOfStudy: { type: String, required: true },
  smoking: { type: Boolean, default: false },
  drinking: { type: Boolean, default: false },
  sleepSchedule: { type: String, enum: ['early_bird', 'night_owl', 'flexible'], default: 'flexible' },
  bio: { type: String, maxLength: 500 },
  status: { type: String, enum: ['looking', 'found', 'hidden'], default: 'looking' }
}, { timestamps: true });

module.exports = mongoose.model('RoommateProfile', roommateProfileSchema);
