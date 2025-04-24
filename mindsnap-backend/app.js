const express = require("express");
const cors = require("cors");
require("dotenv").config();
const mongoose = require("mongoose");

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect("mongodb://127.0.0.1:27017/mindsnap", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

app.use("/api/auth", require("./routes/auth"));
app.use("/api/activities", require("./routes/mindful"));
app.use("/api/goals", require("./routes/goal"));

module.exports = app;
