const Event = require('./event.model');

exports.getEvents = async (req, res, next) => {
  try {
    const events = await Event.find({ status: { $ne: 'cancelled' } }).sort({ date: 1 });
    res.status(200).json({ success: true, count: events.length, data: events });
  } catch (error) { next(error); }
};

exports.registerForEvent = async (req, res, next) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event) return res.status(404).json({ success: false, message: 'Event not found' });
    
    if (event.registeredStudents.includes(req.user.id)) {
      return res.status(400).json({ success: false, message: 'Already registered' });
    }
    
    event.registeredStudents.push(req.user.id);
    await event.save();
    res.status(200).json({ success: true, data: event });
  } catch (error) { next(error); }
};
