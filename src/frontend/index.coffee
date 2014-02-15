express = require("express")
engine = require("ejs-locals")
main = require("./controllers")
app = module.exports = express()
app.use (req, res, next) ->
  Category = require('./models/category')
  Category.find {}, (err, categories) ->
    res.locals.categories = categories
    next()

app.engine "ejs", engine
app.set "view engine", "ejs"
app.set "views", __dirname + "/views"

# GET /
app.get "/", main.index

# GET /page/:slug
app.get '/page/:slug', main.contents.show

# GET *
app.get '*', main.notFound
