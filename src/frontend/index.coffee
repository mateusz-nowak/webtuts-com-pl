express = require("express")
engine = require("ejs-locals")
main = require("./controllers")
app = module.exports = express()

# Fetch categories
app.use (req, res, next) ->
  Category = require './models/category'

  Category.find {}, (err, categories) ->
    res.locals.categories = categories
    next()

app.use (req, res, next) ->
  Post = require './models/post'

  Post.mapReduce
    map: ->
      if this.active == true
        for index of this.tags
          emit @tags[index], 1

    reduce: (previous, current) ->
      count = 0
      for index of current
        count += current[index]
      return count
    limit: 20

  , (err, results) ->
    res.locals.tags = results

    if results.length == 0
        res.locals.tagMaxValue = []
    else
        res.locals.tagMaxValue = results.reduce (a, b) ->
          return a if !b
          return b if !a
          if b.value > a.value
            return a.value
          else
            return b.value

    next()

app.engine "ejs", engine
app.set "view engine", "ejs"
app.set "views", __dirname + "/views"

# GET /
app.get "/", main.index

# GET /page/:slug
app.get '/page/:slug', main.contents.show

# GET /post/:slug
app.get '/post/:slug', main.post.show

# POST /post/:slug
app.post '/post/:slug', main.post.show

# GET /search
app.get '/search', main.search

# GET /category/:category
app.get '/categories/:category', main.category

# GET /write
app.get '/write', main.write

# POST /write
app.post '/write', main.writePost

# GET /comments/:id/remove
app.get '/comments/:id/remove', main.comments.remove

# GET *
app.get '*', main.notFound
