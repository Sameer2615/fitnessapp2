const mongoose = require("mongoose");
const bcrypt = require("bcrypt"); // Make sure you have bcrypt installed: npm install bcrypt

const userSchema = new mongoose.Schema(
  {
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
      sparse: true, // Allows null values, but still provides uniqueness for non-null
    },
  },
  { timestamps: true }
);


userSchema.pre("save", async function (next) {
  // Only hash if the password field is modified
  if (this.isModified("password")) {
    const salt = await bcrypt.genSalt(10); // Generate a salt
    this.password = await bcrypt.hash(this.password, salt); // Hash the password
  }
  next();
});


userSchema.methods.comparePassword = async function (candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// Export the User Mongoose model DIRECTLY
const User = mongoose.model("User", userSchema);
module.exports = User;
