const express = require('express');
const router = express.Router();
const TaskCoontroller = require('../Controllers/task_controller');
const authMiddleware = require('../Middlewares/auth_middleware');

router.use(authMiddleware);

router.get('/:userEmail', TaskCoontroller.fetchTasks);
router.post('/', TaskCoontroller.addTask);
router.patch('/:uniqueId', TaskCoontroller.updateTask);
router.delete('/:uniqueId', TaskCoontroller.deleteTask);

module.exports = router;