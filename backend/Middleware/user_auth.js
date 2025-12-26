const jwt = require('jsonwebtoken');
const userModel = require('../Models/user_model');

const secretKey = process.env.JWT_SECRET;

// Check if JWT_SECRET is set
if (!secretKey || secretKey === 'your_default_secret_key') {
    console.error('WARNING: JWT_SECRET is not properly set in environment variables!');
    process.exit(1);
}

exports.authenticateUser = async (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (!token) {
        return res.status(401).json({ message: 'Access Denied. No Token Provided.' });
    }

    try {
        const decoded = jwt.verify(token, secretKey);
        const user = await userModel.findById(decoded.id);
        if (!user) {
            return res.status(401).json({ message: 'Invalid Token.' });
        }
        req.user = user;
        next();
    } catch (error) {
        res.status(400).json({ message: 'Invalid Token.', data: error.message });
    }
};

exports.authorizeUser = (req, res, next) => {
    const { user } = req;
    const { email } = req.params;

    if (user.email !== email) {
        return res.status(403).json({ message: 'Access Denied. You do not have permission to perform this action.' });
    }
    next();
};