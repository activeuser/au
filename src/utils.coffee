fs      = require 'fs'
path    = require 'path'
{spawn} = require 'child_process'

# The location of exists/existsSync changed in node v0.8.0.
if fs.existsSync
  exports.existsSync = existsSync = fs.existsSync
  exports.exists     = fs.exists
else
  exports.existsSync = existsSync = path.existsSync
  exports.exists     = path.exists

exports.exec = (args, callback) ->
  # Simple serial execution of commands, no error handling
  serial = (arr) ->
    complete = 0
    iterate = ->
      exports.exec arr[complete], ->
        complete += 1
        if complete == arr.length
          return
        else
          iterate()
    iterate()
    # passed callback as second argument
    if typeof opts is 'function'
      callback = opts

  if Array.isArray args
    return serial args

  args = args.split(/\s+/g)
  cmd = args.shift()
  proc = spawn cmd, args

  # echo stdout/stderr
  proc.stdout.on 'data', (data) ->
    process.stdout.write data

  proc.stderr.on 'data', (data) ->
    process.stderr.write data

  # callback on completion
  proc.on 'exit', (code) ->
    if typeof callback is 'function'
      callback null, code
