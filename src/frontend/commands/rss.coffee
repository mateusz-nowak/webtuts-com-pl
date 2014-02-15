app = require(__dirname + "../../../../app")
client = require("mongodb").MongoClient
config = app.get("configuration").mongo
resolveProviders = ->
  providers = []
  providers.push require("./providers/xlab")
  providers.push require("./providers/fabien")
  providers

providers = resolveProviders()
fs = require("fs")
request = require("request")
providers.forEach (provider) ->
  feedParser = require("feedparser")
  posts = []
  addPosts = (posts) ->
    client.connect "mongodb://" + config.host + ":" + config.port + "/" + config.database, config.options or {}, (err, db) ->
      console.warn err  if err
      collection = db.collection("posts")
      posts.forEach (post) ->
        collection.update
          title: post.title
        ,
          $set: post
        ,
          upsert: true
        , (err, res) ->
          console.warn err  if err
          return

        return

      return

    return

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

