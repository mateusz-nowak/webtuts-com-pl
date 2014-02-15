var provider = module.exports = {};

provider.uri = 'http://xlab.pl/feed';
provider.resolve = function(item) {
    return {
        title: item.title,
        link: item.link,
        intro: item.description,
        description: item.description,
        author: item.creator,
    };
};
