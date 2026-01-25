const express = require('express');
const cors = require('cors');
const connectDatabase = require('./Configs/database');
const dotenv = require('dotenv');


dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());
const PORT = process.env.PORT;

connectDatabase();

app.use('/MyTasks/tasks', require('./Routes/task_route'));
app.use('/MyTasks/users', require('./Routes/user_route'));

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});