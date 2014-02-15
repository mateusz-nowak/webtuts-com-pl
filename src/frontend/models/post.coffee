Category = require('./category')
mongoose = require("mongoose")

module.exports = mongoose.model("Post", mongoose.Schema(
  title:
    type: String
    default: ''
  intro:
    type: String
    default: ''
  content:
    type: String
    default: ''
  createdAt:
    type: Date
    default: Date.now
  active:
    type: Boolean
    default: false
  tags:
    type: Array
    default: []
  category:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Category'
))
