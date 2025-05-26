const SocialMediaGoal = require("../models/SocialMediaGoal");

exports.create = async (req, res) => {
  const goal = await SocialMediaGoal.create({
    userId: req.user,
    ...req.body,
  });
  res.status(201).json(goal);
};

exports.getAll = async (req, res) => {
  const goals = await SocialMediaGoal.find({ userId: req.user });
  res.json(goals);
};

exports.update = async (req, res) => {
  const updated = await SocialMediaGoal.findOneAndUpdate(
    { _id: req.params.id, userId: req.user },
    req.body,
    { new: true }
  );
  res.json(updated);
};

exports.delete = async (req, res) => {
  await SocialMediaGoal.findOneAndDelete({ _id: req.params.id, userId: req.user });
  res.json({ message: "Goal deleted" });
};
