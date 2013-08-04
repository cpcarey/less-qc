exports.lessqc = (argv) ->
  fs       = require 'fs'
  process_ = require '../core/process'

  readFile = (inFile, outFile)->
    fs.readFile inFile, 'utf8', (error, data) ->
      if error
        console.error "Could not open file: #{error}"
        process.exit 1

      output = process_.process data

      fs.writeFile outFile, output, (error) ->
        if error
          console.error "Error saving file: #{error}"
          process.exit 1

  if fs.lstatSync(process.argv[2]).isFile()
    readFile process.argv[2], process.argv[3]
  else
    files = fs.readdirSync(process.argv[2])
    for file in files
      if file.split('.')[1] == 'lessqc'
        readFile (process.argv[2] + '/' + file), (process.argv[3] + '/' + file.slice(0, -2))
