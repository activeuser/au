fs = require 'fs'
path = require 'path'
reloader = require './reloader'

# Watch files for changes
watch = do ->
  watched = {}
  (file, callback) ->
    # We only support fs.watch
    return if not fs.watch

    if watched[file]
      watched[file].close()
    try
      watched[file] = fs.watch file, ->
        reloader.reload file
        callback file
    catch err
      if err.code == 'EMFILE'
        console.log 'Too many open files'
        process.exit()
      else
        throw err

watchTree = (dir) ->
  watch dir, ->
    console.log 'Reloading extension'
    reloader.reload dir

  fs.readdir dir, (err, files) ->
    for file in files
      file = path.join dir, file
      do (file) ->
        fs.stat file, (err, stats) ->
          throw err if err
          if stats.isDirectory()
            watchTree file

module.exports = -> watchTree process.cwd()
