var express = require('express');
var engine = require('ejs-locals');
var passport = require('passport');
var gitHubStrategy = require('passport-github').Strategy;
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
    var collection = req.mongo.collection('users');

    collection.update({ githubId: req.user.id }, {$set: req.user}, { upsert: true}, function(err, data) {
        if (err) {
            console.warn(err.message);
        }
        console.log(data);
    });

    res.redirect('/');
});

// GET /authlogout
app.get('/auth/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

app.use(function(req, res, next) {
    var collection = req.mongo.collection('users');

    if (!req.user) {
        res.locals.user = null;
        return next();
    }

    collection.findOne({ githubId: req.user.id }, function(err, user) {
        res.locals.user = user;
        next();
    });
});
