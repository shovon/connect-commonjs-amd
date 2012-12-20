express = require 'express'
path = require 'path'

publicFolder = path.join __dirname, 'public'
srcFolder = path.join __dirname, 'src'

port = process.argv[2]||3000

server = express()

server.configure ->
  server.use express.bodyParser()
  server.use express.methodOverride()
  server.use require('../src/middleware.coffee')({
    src: srcFolder
    dest: publicFolder
  })
  server.use express.static publicFolder
  server.use express.errorHandler
    dumpException: true
    showStack: true
  server.use server.router

server.listen port
console.log "Server listening on port #{port}"
