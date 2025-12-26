// Controllers/task_controller.js
const taskModel = require('../Models/task_model');

// GET ALL TASKS OF A USER
exports.getTask = async (req, res) => {
    try {
        const tasks = await taskModel.find({ user_email: req.params.user_email });
        if (tasks.length > 0) {
            res.status(200).json({
                message: 'Tasks retrieved successfully',
                data: tasks
            });
        } else {
            res.status(404).json({
                message: 'No tasks found for the user'
            });
        }
    } catch (error) {
        res.status(500).json({
            message: 'Failed to retrieve tasks',
            error: error.message
        });
    }
};

// CREATE TASK
exports.createTask = async (req, res) => {
    try {
        const { user_email, unique_id, title, description, category, priority, due_date, is_completed } = req.body;
        
        // Validate required fields
        if (!user_email || !unique_id || !title || !description || !category || !priority || !due_date || is_completed === undefined) {
            return res.status(400).json({
                message: 'All fields are required: user_email, unique_id, title, description, category, priority, due_date, is_completed',
                error: null
            });
        }
        
        const newTask = new taskModel(req.body);
        const savedTask = await newTask.save();

        res.status(201).json({
            message: 'Task created successfully',
            data: savedTask
        });
        
    } catch (error) {
        // Handle duplicate unique_id error
        if (error.code === 11000) {
            return res.status(409).json({
                message: 'Task with this unique_id already exists',
                error: error.message
            });
        }
        res.status(500).json({
            message: 'Failed to create task',
            error: error.message
        });
    }
};

exports.updateTask = async (req, res) => {
    try {
        const updatedTask = await taskModel.findOneAndUpdate(
            { unique_id: req.params.unique_id },
            req.body,
            { new: true }
        );
        
        if (updatedTask) {
            res.status(200).json({
                message: 'Task updated successfully',
                data: updatedTask
            });
        } else {
            res.status(404).json({
                message: 'Task not found'
            });
        }
    } catch (error) {
        res.status(500).json({
            message: 'Failed to update task',
            error: error.message
        });
    }
};


exports.deleteTask = async (req, res) => {
    try {
        const deletedTask = await taskModel.findOneAndDelete({ unique_id: req.params.unique_id });

        if (deletedTask) {
            res.status(200).json({
                message: 'Task deleted successfully'
            });
        } else {
            res.status(404).json({
                message: 'Task not found'
            });
        }
    } catch (error) {
        res.status(500).json({
            message: 'Failed to delete task',
            error: error.message
        });
    }
};
