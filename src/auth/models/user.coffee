mongoose = require("mongoose")

schema = mongoose.Schema(
  fullName: String
  github: String
  gravatar: String
  lastActivity: Date
)

schema.virtual('lastActivityInWords').get ->
  moment = require 'moment'
  moment.lang('pl')

  return moment(this.lastActivity).fromNow()

module.exports = mongoose.model("User", schema)
