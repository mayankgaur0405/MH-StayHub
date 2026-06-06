require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const mongoSanitize = require('express-mongo-sanitize');
const connectDB = require('./config/db');

const app = express();

// Middleware
app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(mongoSanitize());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
});
app.use('/api', limiter);

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

// Route files
const authRoutes = require('./modules/auth/auth.routes');
const collegeRoutes = require('./modules/colleges/college.routes');
const accommodationRoutes = require('./modules/accommodations/accommodation.routes');
const leadRoutes = require('./modules/leads/lead.routes');
const paymentRoutes = require('./modules/payments/payment.routes');
const studentAdvantageRoutes = require('./modules/studentAdvantage/studentAdvantage.routes');
const notificationRoutes = require('./modules/notifications/notification.routes');
const adminRoutes = require('./modules/admin/admin.routes');
const couponRoutes = require('./modules/studentAdvantage/coupon.routes');
const eventRoutes = require('./modules/studentAdvantage/event.routes');
const roommateRoutes = require('./modules/studentAdvantage/roommate.routes');
const marketplaceRoutes = require('./modules/studentAdvantage/marketplace.routes');
const seniorConnectRoutes = require('./modules/studentAdvantage/seniorConnect.routes');

// Mount routers
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/colleges', collegeRoutes);
app.use('/api/v1/accommodations', accommodationRoutes);
app.use('/api/v1/leads', leadRoutes);
app.use('/api/v1/payments', paymentRoutes);
app.use('/api/v1/student-advantage', studentAdvantageRoutes);
app.use('/api/v1/notifications', notificationRoutes);
app.use('/api/v1/admin', adminRoutes);
app.use('/api/v1/coupons', couponRoutes);
app.use('/api/v1/events', eventRoutes);
app.use('/api/v1/roommates', roommateRoutes);
app.use('/api/v1/marketplace', marketplaceRoutes);
app.use('/api/v1/senior-connect', seniorConnectRoutes);

// Basic route
app.get('/', (req, res) => {
  res.send('MH StayHub API is running...');
});

// Error handling middleware
app.use((err, req, res, next) => {
  const statusCode = res.statusCode === 200 ? 500 : res.statusCode;
  res.status(statusCode);
  res.json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? null : err.stack,
  });
});

const PORT = process.env.PORT || 5000;

const startServer = async () => {
  await connectDB();
  
  // If we are using memory server, seed data
  if (mongoose && mongoose.connection.host === '127.0.0.1' && mongoose.connection.port !== 27017) {
     // We are likely in memory server
     const { seedData } = require('./seeder');
     console.log('Detected Memory Server. Auto-seeding mock data...');
     await seedData(true);
  }

  app.listen(PORT, () => {
    console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
  });
};


startServer();
