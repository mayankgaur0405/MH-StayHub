const mongoose = require('mongoose');

const marketplaceItemSchema = new mongoose.Schema({
  seller: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  category: { type: String, enum: ['books', 'cycles', 'electronics', 'furniture', 'other'], required: true },
  condition: { type: String, enum: ['new', 'like_new', 'good', 'fair'], required: true },
  images: [{ type: String }], // Cloudinary URLs
  status: { type: String, enum: ['available', 'sold', 'hidden'], default: 'available' }
}, { timestamps: true });

module.exports = mongoose.model('MarketplaceItem', marketplaceItemSchema);
