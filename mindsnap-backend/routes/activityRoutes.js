const express = require('express');
const router = express.Router();
const { protect } = require('../middlewares/authMiddleware');
const Activity = require('../models/Activity');

router.use(protect);

router.post('/', async (req, res) => {
    const activity = new Activity({ ...req.body, user: req.user._id });
    await activity.save();
    res.status(201).json(activity);
});

router.get('/', async (req, res) => {
    const activities = await Activity.find({ user: req.user._id });
    res.json(activities);
});

module.exports = router;
