const nodemailer = require("nodemailer");
const keys = require("./keys");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: keys.EMAIL_USER,
    pass: keys.EMAIL_PASS,
  },
});

module.exports = transporter;
