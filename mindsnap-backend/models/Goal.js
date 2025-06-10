const mongoose = require('mongoose');

const goalSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    goal: { type: String, required: true },
    deadline: { type: Date }
}, { timestamps: true });

module.exports = mongoose.model('Goal', goalSchema);
