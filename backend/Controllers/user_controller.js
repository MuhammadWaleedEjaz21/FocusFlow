const userModel = require('../Models/user_model');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const secretKey = process.env.JWT_SECRET;

// Ensure JWT_SECRET is set
if (!secretKey) {
    console.error('ERROR: JWT_SECRET is not set in environment variables!');
    process.exit(1);
}

exports.get = async (req,res) => {
    try {
        const users = await userModel.find({email:req.params.email});
        if(users.length === 0)
        {
            return res.status(404).json({
                message : 'No Users Found',
                data : null
            });
        }
        res.status(200).json({
            message : 'Users Fetched Successfully',
            data : users
        });
    } catch (error) {
        res.status(500).json({
            message : 'Failed to Fetch Users',
            data : error.message
        });
    }
};
exports.signup = async (req,res) => {
    const {name,email,password} = req.body;
    
    // Validate required fields
    if (!name || !email || !password) {
        return res.status(400).json({
            message: 'Name, email and password are required',
            data: null
        });
    }
    
    try
    {
        // Check if user already exists
        const existingUser = await userModel.findOne({email});
        if (existingUser) {
            return res.status(409).json({
                message: 'User with this email already exists',
                data: null
            });
        }
        
        const hash_password = await bcrypt.hash(password,10);
        const newUser = new userModel({
            name: name,
            email : email,
            password : hash_password
        });
        const savedUser = await newUser.save();
        
        res.status(201).json({
            message:'Registration Successful',
            data:savedUser
        });
    }
    catch(e)
    {
        res.status(500).json({
            message:'Failed to Register',
            data:e.message
        })
    }
};

exports.patch = async (req,res) => {
    try {
        // Only hash password if it's provided
        if (req.body.password) {
            req.body.password = await bcrypt.hash(req.body.password,10);
        }
        
        // Return updated document with {new: true}
        const updatedUser = await userModel.findOneAndUpdate(
            {email:req.params.email},
            req.body,
            {new: true}
        );
        
        if(!updatedUser)
        {
            return res.status(404).json({
                message : 'User Not Found',
                data : null
            });
        }
        res.status(200).json({
            message : 'User is Updated Successfully',
            data : updatedUser
        })
    } catch (error) {
        res.status(500).json({
            message : 'Failed to Update User',
            data : error.message
        })
        
    }
}

exports.delete = async (req,res) => {
    try {
        const DeletedUser = await userModel.findOneAndDelete({email:req.params.email});
        
        if(!DeletedUser)
        {
            return res.status(404).json({
                message : 'User Not Found',
                data : null
            });
        }
        
        res.status(200).json({
            message : 'User is Deleted Successfully',
            data : DeletedUser
        })
    } catch (error) {
        res.status(500).json({
            message : 'Failed to Delete User',
            data : error.message
        })
    }
};

exports.login = async (req,res) => {
    const {email,password} = req.body;
    
    // Validate required fields
    if (!email || !password) {
        return res.status(400).json({
            message: 'Email and password are required',
            data: null
        });
    }
    
    try {
        const user = await userModel.findOne({email:email});
        if(!user)
        {
            return res.status(404).json({
                message : 'User Not Found',
                data : null
            });
        }
        const isMatch = await bcrypt.compare(password,user.password);
        if(!isMatch)
        {
            return res.status(401).json({
                message : 'Invalid Credentials',
                data : null
            });
        }
        const token = jwt.sign({id: user._id}, secretKey, {expiresIn: '24h'});
        res.status(200).json({
            message : 'Login Successful',
            token : token,
            data : user
        });
    } catch (error) {
        res.status(500).json({
            message : 'Failed to Login',
            data : error.message
        });
    }
};