(->
  fs       = require 'fs'
  process_ = require '../core/process'

  fs.readFile './test/media.lessqc', 'utf8', (error, data) ->
    if error
      console.error "Could not open file: #{error}"
      process.exit 1
    console.log process_.process data
).call @
