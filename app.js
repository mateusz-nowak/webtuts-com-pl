var express = require('express');
var http = require('http');
var app = express();
var yaml = require('yamljs');
var path = require('path');
var sass = require('node-sass');

app.configure('development', function() {
    app.set('configuration', yaml.load('config/development.yml'));
    app.use(express.errorHandler());
});

app.configure('production', function() {
    app.set('configuration', yaml.load('config/production.yml'));
});

app.configure(function() {
    module.paths.push(__dirname+ '/src');
    app.use(sass.middleware({
        src: __dirname + '/public/sass',
        dest: __dirname + '/public/css',
        debug: true,
        prefix: '/css',
        outputStyle: 'compressed'
    }));
    app.use(express.json());
    app.use(express.bodyParser());
    app.use(express.urlencoded());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(app.router);
    app.use(require('./middleware/mongo'));
    app.use(express.session({
        secret: 'secret-hash',
        expires: new Date(Date.now() + 360000),
        maxAge: 360000
    }));
    app.use(express.static(path.join(__dirname, 'public')));
});

app.use(require('main'));

http.createServer(app).listen(process.env.PORT || 3000);
