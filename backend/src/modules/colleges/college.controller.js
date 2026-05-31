const College = require('./college.model');

const getColleges = async (req, res) => {
  try {
    const colleges = await College.find({ isActive: true }).select('-__v');
    res.status(200).json({ success: true, data: colleges });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const getCollegeById = async (req, res) => {
  try {
    const isObjectId = /^[0-9a-fA-F]{24}$/.test(req.params.id);
    const query = isObjectId ? { _id: req.params.id } : { slug: req.params.id };
    
    const college = await College.findOne(query);
    if (!college) {
      return res.status(404).json({ success: false, message: 'College not found' });
    }
    res.status(200).json({ success: true, data: college });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getColleges, getCollegeById };
