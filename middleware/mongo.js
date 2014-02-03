module.exports = function(req, res, next) {
    var client = require('mongodb').MongoClient,
        config = req.app.get('configuration').mongo;

    client.connect('mongodb://' + config.host + ':' + config.port + '/' + config.database, config.options || {}, function(err, db) {
        if (err) {
            next(err);
        }
        req.mongo = db;
        next();
    });
};
