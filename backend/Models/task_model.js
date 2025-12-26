// Models/task_model.js
const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
    user_email: { type: String, required: true },
    unique_id: { type: String, required: true, unique: true },
    title: { type: String, required: true },
    description: { type: String, required: true },
    category: { type: String, required: true },
    priority: { type: String, required: true },
    due_date: { type: Date, required: true },
    is_completed: { type: Boolean, required: true },
}, {
    timestamps: true // Adds createdAt and updatedAt fields
});

module.exports = mongoose.model('Task', taskSchema);
