const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    type: { type: String, required: true },
    duration: { type: Number },
    notes: { type: String }
}, { timestamps: true });

module.exports = mongoose.model('Activity', activitySchema);
