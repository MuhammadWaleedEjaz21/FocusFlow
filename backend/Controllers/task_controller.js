const Task = require('../Models/task_model');


const fetchTasks = async (req, res) => {
    try {
        const tasks = await Task.find({ userEmail: req.params.userEmail });
        res.status(200).json({message : "Tasks fetched successfully",data : tasks });
    } catch (error) {
        res.status(500).json({ message: "Error fetching tasks", error: error.message });
    }
};

const addTask = async (req,res) => {
    try {
        const newTask = new Task(req.body);
        await newTask.save();
        res.status(201).json({ message: "Task added successfully", data: newTask });
    } catch (error) {
        res.status(500).json({ message: "Error adding task", error: error.message });
    }
};

const updateTask = async (req,res) => {
    try {
        const updatedTask = await Task.findOneAndUpdate(
            { uniqueId: req.params.uniqueId },
            req.body,
            { new: true }
        );
        if (!updatedTask) {
            return res.status(404).json({ message: "Task not found" });
        }
        res.status(200).json({ message: "Task updated successfully", data: updatedTask });
    } catch (error) {
        res.status(500).json({ message: "Error updating task", error: error.message });
    }
};

const deleteTask = async (req,res) => {
    try {
        const deletedTask = await Task.findOneAndDelete({ uniqueId: req.params.uniqueId });
        if (!deletedTask) {
            return res.status(404).json({ message: "Task not found" });
        }
        res.status(200).json({ message: "Task deleted successfully", data: deletedTask });
    } catch (error) {
        res.status(500).json({ message: "Error deleting task", error: error.message });
    }
};

module.exports = {
    fetchTasks,
    addTask,
    updateTask,
    deleteTask
};