const User = require('../Models/user_model');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const fetchUser = async (req, res) => {
    try {
        const { userEmail } = req.params;
        const user = await User.findOne({ email: userEmail }).select('-password'); // exclude password
        if (!user) return res.status(404).json({ message: "User not found" });

        res.status(200).json({ message: "User fetched successfully", data: user });
    } catch (error) {
        res.status(500).json({ message: "Error fetching user", error: error.message });
    }
};

const addUser = async (req, res) => {
    try {
        const { fullName, email, password } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: "Email already registered" });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = new User({ fullName, email, password: hashedPassword });
        await newUser.save();

        const userResponse = { email: newUser.email, fullName: newUser.fullName };
        res.status(201).json({ message: "User added successfully", data: userResponse });
    } catch (error) {
        res.status(500).json({ message: "Error adding user", error: error.message });
    }
};

const updateUser = async (req, res) => {
    try {
        const updates = { ...req.body };

        if (updates.password) {
            updates.password = await bcrypt.hash(updates.password, 10);
        }

        const updatedUser = await User.findOneAndUpdate(
            { email: req.params.userEmail },
            updates,
            { new: true }
        ).select('-password');

        if (!updatedUser) return res.status(404).json({ message: "User not found" });

        res.status(200).json({ message: "User updated successfully", data: updatedUser });
    } catch (error) {
        res.status(500).json({ message: "Error updating user", error: error.message });
    }
};

const deleteUser = async (req, res) => {
    try {
        const deletedUser = await User.findOneAndDelete({ email: req.params.userEmail }).select('-password');
        if (!deletedUser) return res.status(404).json({ message: "User not found" });

        res.status(200).json({ message: "User deleted successfully", data: deletedUser });
    } catch (error) {
        res.status(500).json({ message: "Error deleting user", error: error.message });
    }
};

const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({ email });
        if (!user) return res.status(404).json({ message: "User not found" });

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) return res.status(401).json({ message: "Invalid email or password" });

        const token = jwt.sign(
            { email: user.email, id: user._id },
            process.env.JWT_SECRET || 'your_jwt_secret',
            { expiresIn: '1h' }
        );

        const userResponse = { email: user.email, fullName: user.fullName };
        res.status(200).json({ message: "Login successful", token, data: userResponse });
    } catch (error) {
        res.status(500).json({ message: "Error during login", error: error.message });
    }
};

module.exports = {
    fetchUser,
    addUser,
    updateUser,
    deleteUser,
    loginUser
};
