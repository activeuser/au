program = require 'commander'

program
  .command('new [name]')
  .description('create a new app and/or extension')
  .usage('[name] [options]')
  .option('-t, --template [name]', 'template to use')
  .option('-c, --config [config file]', 'config file to use')
  .action (name, opts={}) ->
    if not name
      return console.log 'Name of project required'

    require('./generator') name, opts

help = -> console.log program.helpInformation()

program.parse process.argv

help() unless program.args.length
