// Config/db.js
const mongoose = require('mongoose');

const MongoURL = 'mongodb+srv://Waleed_Ejaz:Pakistan47@clusteralpha.sam3w6q.mongodb.net/FocusFlowDB?appName=ClusterAlpha';

const connectDB = async () => {
    try {
        await mongoose.connect(MongoURL);
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('MongoDB Connection Failed:', error);
    }
};

module.exports = connectDB;
