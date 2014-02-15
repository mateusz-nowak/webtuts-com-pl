module.exports.index = function(req, res) {
    res.render('index', {
        posts: []
    });
};

module.exports.create = function(req, res) {
    res.render('create');
};
