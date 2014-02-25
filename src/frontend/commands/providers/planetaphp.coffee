provider = module.exports = {}
provider.uri = "http://planeta.php.pl/feed"
provider.resolve = (item) ->
  title: item.title
  link: item.link
  intro: item.description
  description: item.description
  rss: 'planeta.php.pl'
