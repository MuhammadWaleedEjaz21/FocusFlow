const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { 
        type: String, 
        required: true, 
        unique: true,
        lowercase: true,
        trim: true,
        match: [/^\S+@\S+\.\S+$/, 'Please provide a valid email address']
    },
    password: { type: String, required: true },
}, {
    timestamps: true // Adds createdAt and updatedAt fields
});

const userModel = mongoose.model('users', userSchema);

module.exports = userModel;