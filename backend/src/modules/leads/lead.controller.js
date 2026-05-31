const Lead = require('./lead.model');
const Accommodation = require('../accommodations/accommodation.model');

const createLead = async (req, res) => {
  try {
    const { accommodation, type = 'visit', preferredDate, notes, source = 'app' } = req.body;
    
    if (!accommodation) {
      return res.status(400).json({ success: false, message: 'Missing required fields' });
    }

    const foundAccommodation = await Accommodation.findById(accommodation);
    if (!foundAccommodation) {
      return res.status(404).json({ success: false, message: 'Accommodation not found' });
    }

    const lead = await Lead.create({
      studentId: req.user._id,
      accommodation,
      type,
      preferredDate,
      notes,
      source,
      status: type === 'token_booking' ? 'pending_owner_approval' : 'pending'
    });

    res.status(201).json({ success: true, data: lead });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const getMyLeads = async (req, res) => {
  try {
    const leads = await Lead.find({ studentId: req.user._id })
      .populate('accommodation', 'name images address pricing')
      .sort({ createdAt: -1 });

    res.status(200).json({ success: true, data: leads });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { createLead, getMyLeads };
