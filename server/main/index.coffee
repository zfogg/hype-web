path               = require "path"

q                  = require "q"

{db} = require "../"



exports.hype = (req, res) ->
  res.json
    hype: true

