const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

const MongoURL = process.env.MONGODB_URI;

if (!MongoURL) {
    console.error('ERROR: MONGODB_URI is not set in environment variables!');
    process.exit(1);
}

const connectDB = async () => {
    try {
        await mongoose.connect(MongoURL);
        console.log('Connected to MongoDB');
        
        // Handle connection errors after initial connection
        mongoose.connection.on('error', (err) => {
            console.error('MongoDB connection error:', err);
        });
        
        mongoose.connection.on('disconnected', () => {
            console.warn('MongoDB disconnected. Attempting to reconnect...');
        });
        
    } catch (error) {
        console.error('MongoDB Connection Failed:', error);
        process.exit(1);
    }
};

module.exports = connectDB;
