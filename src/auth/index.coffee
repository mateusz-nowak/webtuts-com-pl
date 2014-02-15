express = require("express")
engine = require("ejs-locals")
passport = require("passport")
gitHubStrategy = require("passport-github").Strategy
User = require("./models/user")
app = module.exports = express()
app.use passport.initialize()
app.use passport.session()
passport.use new gitHubStrategy(
  clientID: "5374a47ecacaf4ec509b"
  clientSecret: "38cf565072cd0e1f5f0e49c2ae2cbb234079a018"
  callbackURL: "http://localhost:3000/auth/github/callback"
, (accessToken, refreshToken, profile, done) ->
  done null, profile
)
passport.serializeUser (user, done) ->
  done null, user
  return

passport.deserializeUser (obj, done) ->
  done null, obj
  return


# GET /auth/github
app.get "/auth/github", passport.authenticate("github")

# GET /auth/github/callback
app.get "/auth/github/callback", passport.authenticate("github",
  failureRedirect: "/login"
), (req, res) ->
  res.redirect "/"
  return


# GET /authlogout
app.get "/auth/logout", (req, res) ->
  req.logout()
  res.redirect "/"
  return

app.use (req, res, next) ->
  res.locals.flash =
    notice: req.flash("notice")
    error: req.flash("error")
    info: req.flash("info")

  unless req.user
    res.locals.user = null
    return next()
  User.update
    github: req.user.username
  ,
    fullName: req.user.displayName
    gravatar: req.user._json.avatar_url
    github: req.user.username
  ,
    upsert: true
  , (err, rows, resp) ->
    User.findOne
      github: req.user.username
    , (err, doc) ->
      res.locals.user = doc
      next()
      return

    return

  return

