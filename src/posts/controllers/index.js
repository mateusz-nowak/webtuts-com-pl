module.exports.index = function(req, res) {
    var collection = req.mongo.collection('posts');
    var page = req.query.page ? req.query.page : 1;
    var perPage = 5;
    var pagination = require('pagination');

    collection.find({ active: true }).count(function(err, count) {
        var paginator = pagination.create('search', { prelink:'/', current: page, rowsPerPage: perPage, totalResult: count});

        collection.find({ active: true }, { skip: (page-1)*perPage, limit: perPage }).sort({ _id: 1 }).toArray(function(err, posts) {
            var marked = require('marked');

            res.render('index', {
                posts: posts,
                pager: paginator,
                marked: marked
            });
        });
    });
};

module.exports.create = function(req, res) {
    res.render('create');
};
