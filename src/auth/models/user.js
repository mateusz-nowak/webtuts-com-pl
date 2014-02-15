var mongoose = require('mongoose');

module.exports = mongoose.model('User', mongoose.Schema({
    fullName: String,
    github: String,
    gravatar: String
}));
