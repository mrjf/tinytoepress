module.exports = (app) ->

  # allowed configuration keys
  validKeys = ['libraryName', 'books']

  # Set CTB_CONF environemnt var to point to conf file:
  # export CTB_CONF=/path/to/conf.coffee
  if not process.env.CTB_CONF
    throw "Environment variable CTB_CONF is not set; point it to your conf file"
  conf = require process.env.CTB_CONF

  console.log conf

  app.set(key, conf[key]) for key in Object.keys(conf).filter (x) -> x in validKeys
