var mongoose = require('mongoose');

module.exports = mongoose.model('Category', mongoose.Schema({
    name: String,
}));


