program = require('commander')
  .version(require('../package.json').version)

help = -> console.log program.helpInformation()

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

program
  .command('watch [name]')
  .description('watch for changes and reload')
  .action (opts={}) ->
    require('./watch') opts

program
  .command('install')
  .description('install an app or extension')
  .option('-b, --browser [location]', 'Path to browser to use')
  .action (opts={}) ->
    switch process.platform
      when 'darwin'
        {exec} = require 'child_process'
        browser = opts.browser or 'Google\\ Chrome'
        exec "pkill #{browser}", ->
          exec "open -a #{browser} --args --load-extension=#{process.cwd()}"
      else
        console.log 'Unable to install extensions on your platform'

program.parse process.argv

help() unless program.args.length
