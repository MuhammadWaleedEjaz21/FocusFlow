// Routes/task_route.js
const express = require('express');
const router = express.Router();
const controller = require('../Controllers/task_controller');

router.get('/:user_email', controller.getTask);
router.post('/', controller.createTask);
router.patch('/:unique_id', controller.updateTask);
router.delete('/:unique_id', controller.deleteTask);

module.exports = router;
