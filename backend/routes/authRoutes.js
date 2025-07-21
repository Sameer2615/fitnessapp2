const express = require("express");
const {
  registerUser,
  loginUser,
  verifyEmail,
} = require("../controllers/authController");

const router = express.Router();

// User registration route
router.post("/register", registerUser);

// User login route
router.post("/login", loginUser);

// Email verification route
router.get("/verify-email", verifyEmail);

module.exports = router;
