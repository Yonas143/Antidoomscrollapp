const mongoose = require("mongoose");

const SocialMediaGoalSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  platform: { type: String, required: true },
  timeLimit: { type: Number }, // in minutes
  notes: String,
  dateSet: { type: Date, default: Date.now },
});

module.exports = mongoose.model("SocialMediaGoal", SocialMediaGoalSchema);
