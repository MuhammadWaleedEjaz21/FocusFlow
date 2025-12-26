const express = require('express');
const router = express.Router();
const userController = require('../Controllers/user_controller');
const { authorizeUser, authenticateUser } = require('../Middleware/user_auth');


router.get('/:email',authenticateUser,authorizeUser,userController.get);
router.post('/login',userController.login);
router.post('/signup',userController.signup);
router.patch('/:email',authenticateUser,authorizeUser,userController.patch);
router.delete('/:email',authenticateUser,authorizeUser,userController.delete);



module.exports = router;
