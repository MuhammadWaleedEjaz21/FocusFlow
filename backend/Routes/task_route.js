// Routes/task_route.js
const express = require('express');
const router = express.Router();
const controller = require('../Controllers/task_controller');

router.get('/:user_email', controller.getTask);
router.post('/', controller.createTask);
router.patch('/:id', controller.updateTask);
router.delete('/:id', controller.deleteTask);

module.exports = router;
