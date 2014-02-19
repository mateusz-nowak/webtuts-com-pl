provider = module.exports = {}
provider.uri = "http://feeds.fabien.potencier.org/aidedecamp"
provider.resolve = (item) ->
  title: item.title
  link: item.link
  intro: item.description
  description: item.description
  rss: 'fabien.potencier.org'

