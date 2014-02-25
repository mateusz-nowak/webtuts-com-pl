mongoose = require 'mongoose'

schema = mongoose.Schema(
  title:
    type: String
    default: ''
  content:
    type: String
    default: ''
  contactName:
    type: String
    default: []
  contactMail:
    type: String
    default: []
  contactPhone:
    type: String
    default: []
  category:
    type: mongoose.Schema.Types.ObjectId
    ref: 'JobCategory'
  createdAt:
    type: Date
    default: Date.now
)

schema.virtual('getCreatedAtInWords').get ->
  moment = require 'moment'
  moment.lang('pl')

  return moment(this.lastActivity).fromNow()

schema.virtual('contentFormatted').get ->
  marked = require 'marked'

  return marked(this.content)

module.exports = mongoose.model 'JobOffer', schema
