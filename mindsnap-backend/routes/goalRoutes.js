const express = require('express');
const router = express.Router();
const { protect } = require('../middlewares/authMiddleware');
const Goal = require('../models/Goal');

router.use(protect);

router.post('/', async (req, res) => {
    const goal = new Goal({ ...req.body, user: req.user._id });
    await goal.save();
    res.status(201).json(goal);
});

router.get('/', async (req, res) => {
    const goals = await Goal.find({ user: req.user._id });
    res.json(goals);
});

module.exports = router;
