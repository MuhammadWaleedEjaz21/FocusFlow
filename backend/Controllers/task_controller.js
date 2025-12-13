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
        const newTask = new taskModel(req.body);
        const savedTask = await newTask.save();

        res.status(201).json({
            message: 'Task created successfully',
            data: savedTask
        });
        
    } catch (error) {
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
