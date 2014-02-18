mongoose = require 'mongoose'
moment = require 'moment'

Post = require './post'

schema = mongoose.Schema(
  title:
    type: String
    default: ''
  user:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
  createdAt:
    type: Date
    default: Date.now
)

schema.virtual('createdAtFormatted').get ->
  return moment(this.createdAt).format 'YYYY/MM/D h:mm:ss'

module.exports = mongoose.model 'ForumThread', schema
