fs      = require 'fs'
mote    = require 'mote'
wrench  = require 'wrench'
init    = require './initializer'

{basename, join} = require 'path'
{encoding, exec, existsSync} = require './utils'

module.exports = (name, {config, template}) ->
  template = template or 'default'
  src = join __dirname, '../templates', template
  dest = name

  ctx =
    name: basename dest
    user: process.env.USER

  # update context with config options.
  if config
    for key, val of require config
      ctx[key] = val

  # make sure we don't clobber an existing directory.
  if existsSync dest
    return console.log "#{dest} already exists."

  # copy template to dest
  wrench.copyDirSyncRecursive src, dest

  # compile templates with configuration
  for file in wrench.readdirSyncRecursive dest

    file = join dest, file

    if fs.statSync(file).isFile() and not (/\.png$/.test file)
      console.log file
      buffer = fs.readFileSync file
      template = mote.compile buffer.toString()
      fs.writeFileSync file, template ctx

  init(name)