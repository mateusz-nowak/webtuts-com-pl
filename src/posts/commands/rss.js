var app = require(__dirname + '../../../../app');
var client = require('mongodb').MongoClient;
var config = app.get('configuration').mongo;

var resolveProviders = function() {
    var providers = [];

    providers.push(require('./providers/xlab'));

    return providers;
};

var providers = resolveProviders();

var fs = require('fs');
var request = require('request');

providers.forEach(function(provider) {
    var feedParser = require('feedparser');
    var posts = [];

    var addPosts = function(posts) {
        client.connect('mongodb://' + config.host + ':' + config.port + '/' + config.database, config.options || {}, function(err, db) {
            if (err) {
                console.warn(err);
            }

            var collection = db.collection('posts');

            posts.forEach(function(post) {
                collection.update({ title: post.title }, { $set: post }, { upsert: true }, function(err, res) {
                    if (err) {
                        console.warn(err);
                    }
                });
            });
        });
    };

    console.log('Requesting for: ' + provider.uri);
    request(provider.uri)
        .pipe(new feedParser)
        .on('readable', function() {
            var stream = this, item;

            while (item = stream.read()) {
                posts.push(provider.resolve(item));
            }
        })
        .on('end', function() {
            console.log('Adding posts for: ' + provider.uri);

            addPosts(posts);
        });
});
