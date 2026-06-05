const RoommateProfile = require('./roommate.model');

exports.getProfiles = async (req, res, next) => {
  try {
    const profiles = await RoommateProfile.find({ status: 'looking', user: { $ne: req.user.id } })
      .populate('user', 'name gender collegeName');
    res.status(200).json({ success: true, count: profiles.length, data: profiles });
  } catch (error) { next(error); }
};

exports.createProfile = async (req, res, next) => {
  try {
    req.body.user = req.user.id;
    const profile = await RoommateProfile.findOneAndUpdate(
      { user: req.user.id },
      req.body,
      { new: true, upsert: true }
    );
    res.status(200).json({ success: true, data: profile });
  } catch (error) { next(error); }
};
