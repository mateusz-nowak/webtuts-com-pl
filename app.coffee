express = require("express")
app = express()
yaml = require("yamljs")
path = require("path")
sass = require("node-sass")
livereload = require("express-livereload")
app.configure "development", ->
  app.set "configuration", yaml.load("config/development.yml")
  app.use express.errorHandler()
  app.use sass.middleware(
    src: __dirname + "/public/sass"
    dest: __dirname + "/public/css"
    debug: true
    prefix: "/css"
  )
  return

app.configure "production", ->
  app.set "configuration", yaml.load("config/production.yml")
  app.use sass.middleware(
    src: __dirname + "/public/sass"
    dest: __dirname + "/public/css"
    prefix: "/css"
  )
  return

client = require("mongoose")
db = client.connection
config = app.get("configuration").mongo
app.configure ->
  client.connect "mongodb://" + config.host + ":" + config.port + "/" + config.database
  db.once "open", ->
    console.log "Connected to mongo."
    return

  db.on "error", (err) ->
    console.warn err
    return

  livereload app, config = {}
  app.use express.json()
  app.use express.bodyParser()
  app.use express.urlencoded()
  app.use express.methodOverride()
  app.use app.router
  app.use express.cookieParser("keyboard cat")
  app.use express.session(
    secret: "secret-hash"
    expires: new Date(Date.now() + 360000)
    maxAge: 360000
  )
  app.use require("connect-flash")()
  app.use express.static(path.join(__dirname, "public"))
  module.paths.push __dirname + "/src"
  return

app.use require("auth")
app.use require("frontend")
app.use require("backend")
module.exports = app
