mongoose = require 'mongoose'

schema = mongoose.Schema(
  content:
    type: String
    default: ''
  price:
    type: String
    default: []
  job:
    type: mongoose.Schema.Types.ObjectId
    ref: 'JobOffer'
  user:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
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

module.exports = mongoose.model 'JobOfferBid', schema
