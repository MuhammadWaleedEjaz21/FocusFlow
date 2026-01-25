const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config();

const connectDatabase = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URL);
        console.log('Database connected successfully');
    } catch (error) {
        console.error('Database connection error:', error);
        process.exit(1);
    }
}

module.exports = connectDatabase;