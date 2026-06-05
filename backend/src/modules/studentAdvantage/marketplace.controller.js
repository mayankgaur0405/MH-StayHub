const MarketplaceItem = require('./marketplace.model');

exports.getItems = async (req, res, next) => {
  try {
    const items = await MarketplaceItem.find({ status: 'available' })
      .populate('seller', 'name collegeName')
      .sort({ createdAt: -1 });
    res.status(200).json({ success: true, count: items.length, data: items });
  } catch (error) { next(error); }
};

exports.createItem = async (req, res, next) => {
  try {
    req.body.seller = req.user.id;
    if (req.files && req.files.length > 0) {
      req.body.images = req.files.map(file => file.path);
    }
    const item = await MarketplaceItem.create(req.body);
    res.status(201).json({ success: true, data: item });
  } catch (error) { next(error); }
};
