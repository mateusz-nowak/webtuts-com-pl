module.exports.index = (req, res) ->
  res.render "index",
    posts: []

  return

module.exports.create = (req, res) ->
  res.render "create"
  return
