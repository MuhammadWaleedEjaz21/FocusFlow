const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];
        
        if (!token) {
            return res.status(401).json({ message: "No token provided" });
        }
        
        jwt.verify(token, process.env.JWT_SECRET || 'your_jwt_secret', (err, decoded) => {
            if (err) {
                return res.status(401).json({ message: "Invalid or expired token" });
            }
            req.user = decoded;
            next();
        });
        
    } catch (error) {
        res.status(500).json({ message: "Authentication error", error: error.message });
    }
};

module.exports = authMiddleware;
