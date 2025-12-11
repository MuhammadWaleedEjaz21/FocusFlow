// server.js
const express = require('express');
const cors = require('cors');
const connectDB = require('./Config/db');
const taskRoutes = require('./Routes/task_route');

const app = express();
app.use(cors());
app.use(express.json());

// Connect MongoDB
connectDB();

// Routes
app.use('/MyTasks/tasks', taskRoutes);

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
