exports.lessqc = (argv) ->
  fs       = require 'fs'
  process_ = require '../core/process'

  fs.readFile process.argv[2], 'utf8', (error, data) ->
    if error
      console.error "Could not open file: #{error}"
      process.exit 1

    output = process_.process data

    fs.writeFile process.argv[3], output, (error) ->
      if error
        console.error "Error saving file: #{error}"
        process.exit 1

      console.log "#{process.argv[3]} saved"
