const express = require('express');
const app = express();
const path = require('path');

const db = require("./config/mongoose-connection");



const PORT = process.env.PORT || 3000;
app.listen(PORT, (req, res) => {
  console.log(`Server is running on port ${PORT}`);
});