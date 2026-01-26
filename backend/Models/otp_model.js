const mongoose = require('mongoose');

const OtpSchema = new mongoose.Schema({
    userEmail: {
        type: String,
        required: true
    },
    otp: {
        type: String,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: 60 * 10
    }
});

module.exports = mongoose.model("OTP", OtpSchema);
