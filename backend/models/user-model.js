const mongoose = require("mongoose");

// src/models/userModel.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
    },
    is_verified: {
        type: Boolean,
        default: false,
    },
    verification_token: {
        type: String,
        unique: true,
        sparse: true, // Allows null values, but still enforces uniqueness for non-null
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
    updatedAt: {
        type: Date,
        default: Date.now,
    },
});

// Update `updatedAt` field on save
userSchema.pre('save', function(next) {
    this.updatedAt = Date.now();
    next();
});

const User = mongoose.model('User', userSchema);

// --- Now the "model" functions for the controller to use ---

const createUser = async (email, hashedPassword, verificationToken) => {
    const newUser = new User({
        email,
        password: hashedPassword,
        verification_token: verificationToken,
    });
    return await newUser.save();
};

const findUserByEmail = async (email) => {
    return await User.findOne({ email });
};

const findUserByVerificationToken = async (token) => {
    return await User.findOne({ verification_token: token });
};

const updateUserVerificationStatus = async (userId) => {
    return await User.findByIdAndUpdate(
        userId,
        { $set: { is_verified: true, verification_token: null } },
        { new: true } // Return the updated document
    );
};

module.exports = {
    createUser,
    findUserByEmail,
    findUserByVerificationToken,
    updateUserVerificationStatus,
};
// Export the User model for use in other parts of the application
