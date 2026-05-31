const mongoose = require('mongoose');
const slugify = require('slugify');

const accommodationSchema = new mongoose.Schema({
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
  type: {
    type: String,
    enum: ['hostel', 'pg', 'coliving', 'flat'],
    required: true,
  },
  gender: {
    type: String,
    enum: ['boys', 'girls', 'coed'],
    required: true,
  },
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point',
    },
    coordinates: {
      type: [Number],
      required: true,
    }
  },
  address: {
    type: String,
    required: true,
  },
  nearbyColleges: [{
    collegeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'College'
    },
    distanceMeters: Number,
  }],
  verification: {
    status: {
      type: String,
      enum: ['unverified', 'verified', 'premium_verified'],
      default: 'unverified',
    },
    verifiedAt: Date,
    verifiedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    }
  },
  images: [String],
  amenities: [String],
  pricing: {
    startingPrice: {
      type: Number,
      required: true,
    },
    deposit: Number,
  },
  ownerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  ownerContact: {
    phone: String,
    email: String,
    name: String,
  },
  status: {
    type: String,
    enum: ['active', 'hidden'],
    default: 'active',
  }
}, {
  timestamps: true,
});

// Explicit Indexes
accommodationSchema.index({ location: '2dsphere' });
accommodationSchema.index({ 'pricing.startingPrice': 1 }); // For price sorting/filtering
accommodationSchema.index({ 'nearbyColleges.collegeId': 1, 'verification.status': -1 }); // College-based search prioritizing premium

accommodationSchema.pre('save', function () {
  if (this.isModified('name')) {
    this.slug = slugify(this.name + '-' + Date.now().toString().slice(-4), { lower: true, strict: true });
  }
});

module.exports = mongoose.model('Accommodation', accommodationSchema);
