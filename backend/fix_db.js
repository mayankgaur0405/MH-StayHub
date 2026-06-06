require('dotenv').config();
const mongoose = require('mongoose');
const Event = require('./src/modules/studentAdvantage/event.model');

const fixDatabase = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to DB');

    // Seed some Events so Career Hub is not empty
    const existingEvents = await Event.countDocuments();
    if (existingEvents === 0) {
      console.log('Seeding dummy events...');
      await Event.insertMany([
        {
          title: "TCS Off-Campus Drive 2026",
          description: "Mass hiring for freshers. Roles: System Engineer, Digital. CTC: 3.3L - 7L.",
          type: "placement",
          date: new Date(Date.now() + 86400000 * 5),
          location: "GL Bajaj Campus / Online",
          registrationLink: "https://tcs.com/careers",
          seats: 500,
          status: "upcoming"
        },
        {
          title: "Google Summer Intern 2026",
          description: "Software Engineering Internship for Pre-final year students. Remote.",
          type: "internship",
          date: new Date(Date.now() + 86400000 * 15),
          location: "Remote",
          registrationLink: "https://careers.google.com",
          seats: 50,
          status: "upcoming"
        },
        {
          title: "Flutter UI Workshop",
          description: "Learn how to build beautiful mobile apps with Flutter and Riverpod.",
          type: "workshop",
          date: new Date(Date.now() + 86400000 * 2),
          location: "Galgotias D-Block Auditorium",
          registrationLink: "https://example.com/register",
          seats: 120,
          status: "upcoming"
        }
      ]);
      console.log('Seeded 3 events.');
    } else {
        console.log('Events already exist.');
    }

    console.log('Database fix complete!');
    process.exit(0);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
};

fixDatabase();
