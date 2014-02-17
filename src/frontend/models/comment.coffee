mongoose = require("mongoose")
module.exports = mongoose.model("Comment", mongoose.Schema(
  content: String
  user:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
))
