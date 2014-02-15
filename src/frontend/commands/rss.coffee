app = require(__dirname + "../../../../app")
Post = require('../models/post')
resolveProviders = ->
  providers = []
  providers.push require("./providers/xlab")
  providers

providers = resolveProviders()
fs = require("fs")
request = require("request")
providers.forEach (provider) ->
  feedParser = require("feedparser")
  posts = []
  addPosts = (posts) ->
      posts.forEach (post) ->
        Post.update
          title: post.title
        ,
          $set: post
        ,
          upsert: true
        , (err, res) ->

  console.log "Requesting for: " + provider.uri
  request(provider.uri).pipe(new feedParser).on("readable", ->
    stream = this
    item = undefined
    posts.push provider.resolve(item)  while item = stream.read()
    return
  ).on "end", ->
    console.log "Adding posts for: " + provider.uri
    addPosts posts
    console.log "Done."
    return

  return

