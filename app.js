var express = require('express');
var app = express();
var yaml = require('yamljs');
var path = require('path');
var sass = require('node-sass');
var livereload = require('express-livereload');

app.configure('development', function() {
    app.set('configuration', yaml.load('config/development.yml'));
    app.use(express.errorHandler());
    app.use(sass.middleware({
        src: __dirname + '/public/sass',
        dest: __dirname + '/public/css',
        debug: true,
        prefix: '/css'
    }));
});

app.configure('production', function() {
    app.set('configuration', yaml.load('config/production.yml'));
    app.use(sass.middleware({
        src: __dirname + '/public/sass',
        dest: __dirname + '/public/css',
        prefix: '/css'
    }));
});

var client = require('mongoose');
var db = client.connection;
var config = app.get('configuration').mongo;

app.configure(function() {
    client.connect('mongodb://' + config.host + ':' + config.port + '/' + config.database);

    db.once('open', function() {
        console.log('Connected to mongo.');
    });
    db.on('error', function(err) {
        console.warn(err);
    });
    livereload(app, config={});
    app.use(express.json());
    app.use(express.bodyParser());
    app.use(express.urlencoded());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.cookieParser('keyboard cat'));
    app.use(express.session({
        secret: 'secret-hash',
        expires: new Date(Date.now() + 360000),
        maxAge: 360000
    }));
    app.use(require('connect-flash')());
    app.use(express.static(path.join(__dirname, 'public')));
    module.paths.push(__dirname+ '/src');
});

app.use(require('auth'));
app.use(require('frontend'));
//app.use(require('backend'));

module.exports = app;
