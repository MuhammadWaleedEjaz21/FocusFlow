// server.js
const express = require('express');
const cors = require('cors');
const connectDB = require('./Config/db');
const taskRoutes = require('./Routes/task_route');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

connectDB();

// Routes
app.use('/MyTasks/tasks', taskRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
