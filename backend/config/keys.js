module.exports = {
  JWT_SECRET: process.env.JWT_SECRET || "your_jwt_secret_key",
  EMAIL_USER: process.env.EMAIL_USER || "your_email@gmail.com",
  EMAIL_PASS: process.env.EMAIL_PASS || "your_email_app_password", 
  FRONTEND_URL: process.env.FRONTEND_URL || "http://localhost:3000",
};
