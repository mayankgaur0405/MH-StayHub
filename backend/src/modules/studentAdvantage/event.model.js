const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  date: { type: Date, required: true },
  location: { type: String, required: true }, // "Online", "Campus A", etc.
  type: { type: String, enum: ['placement', 'internship', 'workshop', 'hackathon', 'meetup'], required: true },
  seats: { type: Number, required: true },
  registeredStudents: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  status: { type: String, enum: ['upcoming', 'ongoing', 'completed', 'cancelled'], default: 'upcoming' },
  minimumTier: { type: String, enum: ['free', 'verified', 'premium'], default: 'free' },
  imageUrl: { type: String } // Cloudinary URL
}, { timestamps: true });

module.exports = mongoose.model('Event', eventSchema);
