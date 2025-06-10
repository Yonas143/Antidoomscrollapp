const express = require('express');
const router = express.Router();
const { protect } = require('../middlewares/authMiddleware');
const User = require('../models/User');

router.use(protect);

router.get('/users', async (req, res) => {
    if (!req.user.isAdmin) return res.status(403).json({ message: 'Access denied' });
    const users = await User.find().select('-password');
    res.json(users);
});

module.exports = router;
