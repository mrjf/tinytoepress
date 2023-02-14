fs = require 'fs'

foo = fs.read '/tmp/foo'

console.log foo

phantom.exit()