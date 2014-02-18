mongoose = require 'mongoose'

schema = mongoose.Schema(
  content:
    type: String
    default: ''
  thread:
    type: mongoose.Schema.Types.ObjectId
    ref: 'ForumThread'
  user:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
  createdAt:
    type: Date
    default: Date.now
)

schema.virtual('contentFormatted').get ->
  marked = require 'marked'

  return marked(this.content)

module.exports = mongoose.model 'ForumPost', schema
