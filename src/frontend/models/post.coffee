require './category'
require './comment'

mongoose = require 'mongoose'
moment = require 'moment'
marked = require 'marked'

schema = mongoose.Schema(
  title:
    type: String
    default: ''
  slug:
    type: String
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
  comments: [
    type: mongoose.Schema.Types.ObjectId
    ref: 'Comment'
  ]
)

schema.virtual('createdAtFormatted').get ->
  return moment(this.createdAt).format 'YYYY/MM/D h:mm:ss'

schema.virtual('contentFormatted').get ->
  return marked(this.content)

schema.virtual('introFormatted').get ->
  return marked(this.intro)

module.exports = mongoose.model("Post", schema)
