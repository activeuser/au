fs     = require 'fs'
path   = require 'path'

auJsPath = require.resolve('activeuser.js')
console.log 'js: ' + auJsPath

module.exports = (name = process.cwd()) ->
  console.log 'initializing...' + name
  #create the .au folder
  fs.readdir name, (err, files) ->
    for file in files
      if file == 'ext'
        name = path.join name, 'ext'
        break
  
    console.log name
 
    au_dir = path.join name, '.au/'
    console.log 'au_dir: ' + au_dir

    fs.mkdir au_dir, ->
      dest = fs.createWriteStream(path.join au_dir, 'au.js')
      readStream = fs.createReadStream auJsPath
      readStream.pipe(dest)

    console.log '...finished init.'

