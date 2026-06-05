const SeniorQuery = require('./seniorQuery.model');

exports.getQueries = async (req, res, next) => {
  try {
    const queries = await SeniorQuery.find()
      .populate('author', 'name collegeName')
      .populate('replies.author', 'name role')
      .sort({ createdAt: -1 });
    res.status(200).json({ success: true, count: queries.length, data: queries });
  } catch (error) { next(error); }
};

exports.createQuery = async (req, res, next) => {
  try {
    req.body.author = req.user.id;
    const query = await SeniorQuery.create(req.body);
    res.status(201).json({ success: true, data: query });
  } catch (error) { next(error); }
};

exports.addReply = async (req, res, next) => {
  try {
    const query = await SeniorQuery.findById(req.params.id);
    if (!query) return res.status(404).json({ success: false, message: 'Query not found' });

    query.replies.push({
      author: req.user.id,
      content: req.body.content,
      isSenior: req.user.role !== 'student' // Simplification
    });
    
    query.status = 'answered';
    await query.save();
    
    res.status(200).json({ success: true, data: query });
  } catch (error) { next(error); }
};
