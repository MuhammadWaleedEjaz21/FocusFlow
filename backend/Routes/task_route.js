// Routes/task_route.js
const express = require('express');
const router = express.Router();
const controller = require('../Controllers/task_controller');
const { authenticateUser } = require('../Middleware/user_auth');

router.get('/:user_email', authenticateUser, controller.getTask);
router.post('/', authenticateUser, controller.createTask);
router.patch('/:unique_id', authenticateUser, controller.updateTask);
router.delete('/:unique_id', authenticateUser, controller.deleteTask);

module.exports = router;
