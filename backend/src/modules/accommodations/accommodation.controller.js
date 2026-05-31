const Accommodation = require('./accommodation.model');

const getAccommodations = async (req, res) => {
  try {
    const { lat, lng, radius = 5000, type, gender, maxPrice, collegeId } = req.query;

    let query = { status: 'active' };

    // Geospatial search
    if (lat && lng) {
      query.location = {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(lng), parseFloat(lat)]
          },
          $maxDistance: parseInt(radius)
        }
      };
    }

    if (type) query.type = type;
    if (gender) query.gender = gender;
    if (maxPrice) query['pricing.startingPrice'] = { $lte: parseInt(maxPrice) };
    
    if (collegeId) {
      query['nearbyColleges.collegeId'] = collegeId;
    }

    // Sort by premium verified if collegeId is searched
    let sortObj = {};
    if (collegeId) {
       sortObj = { 'verification.status': -1 }; // premium_verified > verified > unverified
    }

    const accommodations = await Accommodation.find(query)
      .sort(sortObj)
      .limit(50)
      .select('-ownerContact'); // Hide owner contact in list view

    res.status(200).json({ success: true, count: accommodations.length, data: accommodations });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const getAccommodationById = async (req, res) => {
  try {
    const isObjectId = /^[0-9a-fA-F]{24}$/.test(req.params.id);
    const query = isObjectId ? { _id: req.params.id } : { slug: req.params.id };

    const accommodation = await Accommodation.findOne(query)
      .populate('nearbyColleges.collegeId', 'name city slug');
      
    if (!accommodation) {
      return res.status(404).json({ success: false, message: 'Accommodation not found' });
    }
    res.status(200).json({ success: true, data: accommodation });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getAccommodations, getAccommodationById };
