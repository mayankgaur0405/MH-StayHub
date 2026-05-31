require('dotenv').config();
const mongoose = require('mongoose');
const connectDB = require('./config/db');
const College = require('./modules/colleges/college.model');
const Accommodation = require('./modules/accommodations/accommodation.model');
const User = require('./modules/users/user.model');
const Lead = require('./modules/leads/lead.model');
const Payment = require('./modules/payments/payment.model');

const seedData = async (isAutoSeed = false) => {
  try {
    if (!isAutoSeed) {
      await connectDB();
    }
    
    console.log('Clearing existing data...');
    await College.deleteMany();
    await Accommodation.deleteMany();
    await User.deleteMany();
    await Lead.deleteMany();
    await Payment.deleteMany();

    console.log('Creating Admin User...');
    const admin = await User.create({
      phone: '+919999999999',
      name: 'Super Admin',
      role: 'admin',
      email: 'admin@mhstayhub.com'
    });

    const student = await User.create({
      phone: '+918888888888',
      name: 'Test Student',
      role: 'student',
      email: 'student@example.com'
    });

    console.log('Seeding Colleges...');
    const collegesData = [
      { name: 'GL Bajaj Institute of Technology', city: 'Greater Noida', state: 'UP', location: { type: 'Point', coordinates: [77.4820, 28.4731] }, isActive: true },
      { name: 'Galgotias University', city: 'Greater Noida', state: 'UP', location: { type: 'Point', coordinates: [77.5385, 28.3614] }, isActive: true },
      { name: 'Sharda University', city: 'Greater Noida', state: 'UP', location: { type: 'Point', coordinates: [77.4821, 28.4720] }, isActive: true },
      { name: 'Bennett University', city: 'Greater Noida', state: 'UP', location: { type: 'Point', coordinates: [77.5855, 28.3499] }, isActive: true },
      { name: 'NIET', city: 'Greater Noida', state: 'UP', location: { type: 'Point', coordinates: [77.4900, 28.4600] }, isActive: true }
    ];
    const colleges = await College.create(collegesData);

    console.log('Generating 25 Accommodations...');
    const imagesList = [
      'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=500&q=80',
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500&q=80',
      'https://images.unsplash.com/photo-1502672260266-1c1cd2cb94bd?w=500&q=80',
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500&q=80',
      'https://images.unsplash.com/photo-1497366216548-37526070297c?w=500&q=80'
    ];
    const types = ['hostel', 'pg', 'coliving', 'flat'];
    const genders = ['boys', 'girls', 'coed'];
    const statuses = ['verified', 'premium_verified', 'unverified'];
    
    const accommodations = [];
    for (let i = 1; i <= 25; i++) {
      const collegeIndex = i % 5;
      const type = types[i % 4];
      const gender = genders[i % 3];
      const price = 6000 + (i * 500); // 6500 to 18500
      
      const acc = {
        name: `Premium ${type.toUpperCase()} ${i} near ${colleges[collegeIndex].name.split(' ')[0]}`,
        type: type,
        gender: gender,
        description: `Experience the best ${type} life with top-notch amenities. Perfect for students of ${colleges[collegeIndex].name}. Highly secure and vibrant community.`,
        location: { 
          type: 'Point', 
          // Slightly random offset near college
          coordinates: [
            colleges[collegeIndex].location.coordinates[0] + (Math.random() * 0.01 - 0.005), 
            colleges[collegeIndex].location.coordinates[1] + (Math.random() * 0.01 - 0.005)
          ] 
        },
        address: `Sector ${i % 10 + 1}, Knowledge Park, Greater Noida`,
        nearbyColleges: [{ collegeId: colleges[collegeIndex]._id, distanceMeters: (i * 100) % 2000 + 100 }],
        verification: { status: statuses[i % 3], verifiedAt: new Date(), verifiedBy: admin._id },
        images: [imagesList[i % 5], imagesList[(i + 1) % 5]],
        amenities: ['AC', 'WiFi', 'Food', 'Gym', 'Laundry'].slice(0, 3 + (i % 3)),
        pricing: { startingPrice: price, deposit: price * 1.5 },
        ownerId: admin._id,
        ownerContact: { phone: `+91999999${i.toString().padStart(4, '0')}`, name: `Owner ${i}`, email: `owner${i}@test.com` }
      };
      accommodations.push(acc);
    }
    
    const insertedAccs = await Accommodation.create(accommodations);

    console.log('Seeding Sample Leads and Payments...');
    const sampleAcc = insertedAccs[0];
    
    // Seed Lead
    const lead = await Lead.create({
      studentId: student._id,
      accommodation: sampleAcc._id,
      type: 'visit',
      preferredDate: new Date(Date.now() + 86400000),
      notes: 'I want to see the gym.',
      status: 'pending',
      source: 'app'
    });

    // Seed Payment
    await Payment.create({
      orderId: 'order_test_123',
      paymentId: 'pay_test_456',
      signature: 'test_signature_hash',
      amount: 99,
      status: 'paid',
      user: student._id,
      accommodation: sampleAcc._id
    });

    // Update Lead to token_booking
    await Lead.create({
      studentId: student._id,
      accommodation: insertedAccs[1]._id,
      type: 'token_booking',
      status: 'pending_owner_approval',
      payment: {
        amount: 99,
        transactionId: 'pay_test_456',
        status: 'success'
      }
    });

    // Add saved accommodation
    await User.findByIdAndUpdate(student._id, { $addToSet: { savedAccommodations: sampleAcc._id } });

    console.log('Test Data Seeded Successfully!');
    console.log(`- ${colleges.length} Colleges`);
    console.log(`- ${insertedAccs.length} Accommodations`);
    console.log(`- 2 Users (Admin, Student)`);
    console.log(`- 2 Leads`);
    console.log(`- 1 Payment`);

    if (!isAutoSeed) {
      process.exit();
    }
  } catch (error) {
    console.error('Error importing data:', error);
    if (!isAutoSeed) {
      process.exit(1);
    }
  }
};

if (require.main === module) {
  seedData();
}

module.exports = { seedData };
