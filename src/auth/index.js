var express = require('express');
var engine = require('ejs-locals');
var passport = require('passport');
var gitHubStrategy = require('passport-github').Strategy;
var User = require('./models/user');
var app = module.exports = express();

app.use(passport.initialize());
app.use(passport.session());

passport.use(new gitHubStrategy({
    clientID: '5374a47ecacaf4ec509b',
    clientSecret: '38cf565072cd0e1f5f0e49c2ae2cbb234079a018',
    callbackURL: "http://localhost:3000/auth/github/callback"
}, function(accessToken, refreshToken, profile, done) {
    return done(null, profile);
}));

passport.serializeUser(function(user, done) {
    done(null, user);
});

passport.deserializeUser(function(obj, done) {
    done(null, obj);
});

// GET /auth/github
app.get('/auth/github', passport.authenticate('github'));

// GET /auth/github/callback
app.get('/auth/github/callback', passport.authenticate('github', {
    failureRedirect: '/login'
}), function(req, res) {
    res.redirect('/');
});

// GET /authlogout
app.get('/auth/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

app.use(function(req, res, next) {
    res.locals.flash = {
        notice: req.flash('notice'),
        error: req.flash('error'),
        info: req.flash('info')
    };

    if (!req.user) {
        res.locals.user = null;
        return next();
    }

    User.update({ github: req.user.username }, {
        fullName: req.user.displayName,
        gravatar: req.user._json.avatar_url,
        github: req.user.username
    }, { upsert: true }, function(err, rows, resp) {
        User.findOne({ github: req.user.username }, function(err, doc) {
            res.locals.user = doc;
            next();
        });
    });
});
