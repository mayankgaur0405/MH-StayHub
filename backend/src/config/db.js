const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');

let mongoServer;

const connectDB = async () => {
  try {
    let uri = process.env.MONGODB_URI;

    try {
      // First try to connect to the configured URI (e.g. local instance or Atlas)
      await mongoose.connect(uri, { serverSelectionTimeoutMS: 2000 });
      console.log(`MongoDB Connected: ${mongoose.connection.host}`);
    } catch (err) {
      console.log('Failed to connect to primary MongoDB, falling back to in-memory database for testing...');
      // Start in-memory server if local Mongo is not running
      mongoServer = await MongoMemoryServer.create();
      const inMemoryUri = mongoServer.getUri();
      
      await mongoose.disconnect(); // Clear the failed state
      await mongoose.connect(inMemoryUri);
      console.log(`MongoDB Memory Server Connected: ${inMemoryUri}`);
    }
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
