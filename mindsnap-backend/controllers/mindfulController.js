const MindfulActivity = require("../models/MindfulActivity");

exports.create = async (req, res) => {
  const { activity, description } = req.body;
  const newActivity = await MindfulActivity.create({
    userId: req.user,
    activity,
    description,
  });
  res.status(201).json(newActivity);
};

exports.getAll = async (req, res) => {
  const activities = await MindfulActivity.find({ userId: req.user });
  res.json(activities);
};

exports.update = async (req, res) => {
  const updated = await MindfulActivity.findOneAndUpdate(
    { _id: req.params.id, userId: req.user },
    req.body,
    { new: true }
  );
  res.json(updated);
};

exports.delete = async (req, res) => {
  await MindfulActivity.findOneAndDelete({ _id: req.params.id, userId: req.user });
  res.json({ message: "Deleted" });
};
