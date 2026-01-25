const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
    userEmail : { type: String, required: true },
    uniqueId: { type: String, required: true, unique: true },
    title: { type: String, required: true },
    description : { type: String, required: true },
    category : { type: String, required: true },
    priority : { type: String, required: true , enum: ['low', 'medium', 'high'] },
    dueDate : { type: Date, required: true },
    isCompleted : { type: Boolean, required: true }
});

const Task = mongoose.model('Task', taskSchema);

module.exports = Task;