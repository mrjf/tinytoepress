routes = (app) ->

  app.get '/', (req, res) ->
    res.render 'index'

  app.get '/foo', (req, res) ->
    res.send 'Foollo World'

module.exports = routes
