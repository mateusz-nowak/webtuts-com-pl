module.exports.categories = {};

module.exports.dashboard = function(req, res) {
    res.render('dashboard');
};

module.exports.categories.index = function(req, res) {
    res.render('categories/index');
};
