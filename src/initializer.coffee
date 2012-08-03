fs     = require 'fs'
path   = require 'path'

auJsPath = require.resolve('activeuser.js')

module.exports = (name = process.cwd()) ->
  #create the .au folder
  fs.readdir name, (err, files) ->
    for file in files
      if file == 'ext'
        name = path.join name, 'ext'
        break

    au_dir = path.join name, '.au/'

    fs.mkdir au_dir, ->
      dest = fs.createWriteStream(path.join au_dir, 'au.js')
      console.log(dest.path)
      readStream = fs.createReadStream auJsPath
      readStream.pipe(dest)


