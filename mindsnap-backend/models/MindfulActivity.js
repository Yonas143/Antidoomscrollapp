const mongoose = require("mongoose");

const MindfulActivitySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  activity: { type: String, required: true },
  description: String,
  date: { type: Date, default: Date.now },
});

module.exports = mongoose.model("MindfulActivity", MindfulActivitySchema);
