express = require("express")
engine = require("ejs-locals")
main = require("./controllers")
app = module.exports = express()
app.use (req, res, next) ->
  res.locals.categories = []
  next()
  return

app.engine "ejs", engine
app.set "view engine", "ejs"
app.set "views", __dirname + "/views"
app.get "/", main.index
