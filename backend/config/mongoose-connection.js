const mongoose = require("mongoose");
const config = require("config");

mongoose
  .connect(`${config.get("MONGODB_URI")}/backend`)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.error("MongoDB connection error:", err);
  });

module.exports = mongoose.connection;
