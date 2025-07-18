const jwt = require('jsonwebtoken');
const keys = require("../config/keys");

const generateToken = (payload) => {
  return jwt.sign(payload, config.JWT_SECRET, { expiresIn: "1h" }); // Token expires in 1 hour
};

const verifyToken = (token) => {
  try {
    return jwt.verify(token, keys.JWT_SECRET);
  } catch (error) {
    return null; // Token is invalid or expired
  }
};

module.exports = { generateToken, verifyToken };