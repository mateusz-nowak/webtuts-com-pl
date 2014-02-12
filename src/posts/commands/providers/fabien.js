var provider = module.exports = {};

provider.uri = 'http://feeds.fabien.potencier.org/aidedecamp';
provider.resolve = function(item) {
    return {
        title: item.title,
        link: item.link,
        intro: item.description,
        author: 'Fabien Potencier',
        twitter: '@fabpot',
        tags: 'php,symfony2,symfony'
    };
};
