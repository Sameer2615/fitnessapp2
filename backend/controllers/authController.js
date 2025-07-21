const User = require("../models/user-model");
const bcrypt = require("bcrypt"); 
const { generateToken } = require("../utils/jwt");
const transporter = require("../config/mailer");
const keys = require("../config/keys");
const crypto = require("crypto");

const registerUser = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Please enter all fields" });
  }

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ message: "User already exists with this email" });
    }

    
    const verificationToken = crypto.randomBytes(32).toString("hex");

    
    const newUser = new User({
      email,
      password,
      verification_token: verificationToken,
      is_verified: false, // Ensure it's explicitly set
    });

    await newUser.save();

    
    const verificationLink = `${keys.FRONTEND_URL}/verify-email?token=${verificationToken}`; // Adjust this URL for your Flutter app

    const mailOptions = {
      from: keys.EMAIL_USER,
      to: newUser.email,
      subject: "Verify Your Email Address",
      html: `
                <p>Hello,</p>
                <p>Thank you for registering. Please verify your email by clicking on the link below:</p>
                <p><a href="${verificationLink}">Verify Email Address</a></p>
                <p>This link is valid for a limited time. If you did not register for this account, please ignore this email.</p>
            `,
    };

    await transporter.sendMail(mailOptions);

    res.status(201).json({
      message:
        "Registration successful! Please check your email for a verification link.",
    });
  } catch (error) {
    console.error("Error during registration:", error);
    res
      .status(500)
      .json({
        message: "Server error during registration",
        error: error.message,
      });
  }
};


const loginUser = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Please enter all fields" });
  }

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    // Check if the user's email is verified
    if (!user.is_verified) {
      return res
        .status(401)
        .json({ message: "Please verify your email to log in." });
    }

    
    const isMatch = await user.comparePassword(password);

    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    // If credentials are valid and email is verified, generate and return JWT
    const token = generateToken({
      id: user._id,
      email: user.email,
      is_verified: user.is_verified,
    });

    res.json({
      _id: user._id,
      email: user.email,
      is_verified: user.is_verified,
      token,
      message: "Login successful!",
    });
  } catch (error) {
    console.error("Error during login:", error);
    res
      .status(500)
      .json({ message: "Server error during login", error: error.message });
  }
};


const verifyEmail = async (req, res) => {
  const { token } = req.query;

  if (!token) {
    return res.status(400).json({ message: "Verification token is missing." });
  }

  try {
    const user = await User.findOne({ verification_token: token });

    if (!user) {
      return res
        .status(400)
        .json({ message: "Invalid or expired verification token." });
    }

    

    user.is_verified = true;
    user.verification_token = undefined; // Nullify the token after use
    await user.save();


    res
      .status(200)
      .json({ message: "Email successfully verified! You can now log in." });


  } catch (error) {
    console.error("Error during email verification:", error);
    res
      .status(500)
      .json({
        message: "Server error during email verification",
        error: error.message,
      });
  }
};

module.exports = {
  registerUser,
  loginUser,
  verifyEmail,
};
