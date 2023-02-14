express = require 'express'
assets = require 'connect-assets'

app = express()

app.use assets()
app.use express.bodyParser()
app.set 'view engine', 'jade'

require('./config')(app)

app.use(express.favicon(__dirname + '/assets/img/toe.ico'))

app.locals.pretty = true;

library = require('./library')(app.get('libraryName'), app.get('books'))

app.use '/img', express.static(__dirname + '/assets/img')
app.use '/jslib', express.static(__dirname + '/assets/jslib')

app.all '*', (req, res, next) ->
  req.library = library
  next()

require('./routes/index')(app)
require('./routes/paginate')(app)
require('./routes/read')(app)

port = process.env.PORT or 3000
app.listen port
console.log 'Listening on port ' + port
