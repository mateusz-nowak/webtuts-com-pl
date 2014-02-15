var mongoose = require('mongoose');

module.exports = mongoose.model('Post', mongoose.Schema({
    title: String,
    intro: String,
    description: String,
    createdAt: { type: Date, default: Date.now},
    active: { type: Boolean, default: false},
    tags: Array,
    category: { type: mongoose.Types.ObjectId, ref: 'Category' }
}));

