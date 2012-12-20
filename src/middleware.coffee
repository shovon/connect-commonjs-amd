url = require 'url'
path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
_ = require 'underscore'
debug = (require 'debug')('connect-commonjs-amd')

name = 'connect-commonjs-amd'

module.exports = (options = {}) ->
  debug 'Initialized %s', name

  if not _.isString options.src
    throw new Error "An `src` option must be specified."
  if not _.isString options.dest
    throw new Error "A `dest` option must be specified."

  debug 'All systems go'

  return (req, res, next) ->
    return next() if req.method isnt 'GET' and req.method isnt 'HEAD'
    pathname = url.parse(req.url).pathname
    if /\.js$/.test pathname
      debug '%s is believed to be a JavaScript file', pathname
      jsPath = path.join options.dest, pathname
      srcPath = path.join options.src, pathname

      error = (err) ->
        arg = if err.code is 'ENOENT' then null else err
        next arg

      compile = ->
        debug 'Trying to compile.'
        fs.readFile srcPath, 'utf8', (err, str) ->
          return error if err
          debug
          js = toCommonJs str
          mkdirp path.dirname(jsPath), 0o0700, (err) ->
            debug 'created a folder at %s', path.dirname jsPath
            return error if err
            fs.writeFile jsPath, js, 'utf8', next

      return compile() if options.force

      debug 'Stat-ing %s', srcPath
      fs.stat srcPath, (err, srcStats) ->
        return error err if err
        debug 'No errors after looking up %s', srcPath
        fs.stat jsPath, (err, jsStats) ->
          if err
            if err.code is 'ENOENT'
              compile()
            else
              next err
          else
            if srcStats.mtime > jsStats.mtime
              compile()
            else
              next()

    else next()

module.exports.toCommonJs = toCommonJs = (str) ->
  requireCalls = str.match /require\((\s+)?('[^'\\]*(?:\\.[^'\\]*)*'|"[^"\\]*(?:\\.[^"\\]*)*")(\s+)?\)/g
  requireCalls = requireCalls.map (str) ->
    return (str.match /('[^'\\]*(?:\\.[^'\\]*)*'|"[^"\\]*(?:\\.[^"\\]*)*")/)[0]
  str = "define([#{requireCalls.join ', '}], function () {\nvar module = { exports: {} };\n\n#{str}\n\nreturn module.exports;\n});"
  return str
