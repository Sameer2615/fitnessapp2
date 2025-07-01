const mongoose = require("mongoose");
require("dotenv").config();

mongoose
  .connect(`${process.env.MONGODB_URI}/backend`)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.error("MongoDB connection error:", err);
  });

module.exports = mongoose.connection;
