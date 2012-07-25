{existsSync} = require './utils'

# If `../src` exists then require the CoffeeScript source files.
if existsSync __dirname + '/../src'
  require 'coffee-script'
  wrapper = require '../src/wrapper'
else
  wrapper = require './wrapper'

module.exports = wrapper
