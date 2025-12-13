const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

const MongoURL = process.env.MONGODB_URI;

const connectDB = async () => {
    try {
        await mongoose.connect(MongoURL);
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('MongoDB Connection Failed:', error);
    }
};

module.exports = connectDB;
