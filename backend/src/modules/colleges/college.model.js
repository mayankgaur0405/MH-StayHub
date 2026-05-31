const mongoose = require('mongoose');
const slugify = require('slugify');

const collegeSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  slug: {
    type: String,
    unique: true,
    index: true,
  },
  city: {
    type: String,
    required: true,
  },
  state: {
    type: String,
    required: true,
  },
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point',
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true,
    }
  },
  logo: String,
  isActive: {
    type: Boolean,
    default: true,
  }
}, {
  timestamps: true,
});

// Explicit geospatial index for nearby college search
collegeSchema.index({ location: '2dsphere' });

// Middleware to auto-generate slug before saving
collegeSchema.pre('save', function () {
  if (this.isModified('name')) {
    this.slug = slugify(this.name, { lower: true, strict: true });
  }
});

module.exports = mongoose.model('College', collegeSchema);
