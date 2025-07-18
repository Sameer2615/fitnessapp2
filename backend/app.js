const express = require('express');
const dotenv = require("dotenv");

const path = require('path');

dotenv.config();

const app = express();

const db = require("./config/mongoose-connection");

const authRoutes = require("./routes/authRoutes");

app.use(express.json());

app.use("/api/auth", authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, (req, res) => {
  console.log(`Server is running on port ${PORT}`);
});