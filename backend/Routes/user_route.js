const express = require('express');
const router = express.Router();
const UserController = require('../Controllers/user_controller');
const authMiddleware = require('../Middlewares/auth_middleware');

router.get('/:userEmail', authMiddleware, UserController.fetchUser);
router.post('/signup', UserController.addUser);
router.post('/login', UserController.loginUser);
router.patch('/:userEmail', authMiddleware, UserController.updateUser);
router.delete('/:userEmail', authMiddleware, UserController.deleteUser);

module.exports = router;