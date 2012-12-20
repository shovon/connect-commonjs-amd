expect = require 'expect.js'
rimraf = require 'rimraf'
path = require 'path'
fs = require 'fs'
connectCommonJsAmd = require '../src/middleware.coffee'
debug = (require 'debug')('test')


describe 'middleware', ->
  it 'should add an AMD clause around JavaScript files, and then output the code', (done) ->
    rimraf (path.join __dirname, '..', 'sample', 'public'), (err) ->
      # Expect there to be no errors. When `err` is falsy, then there aren't any
      # errors.
      expect(err).to.not.be.ok()
      options =
        src: path.join __dirname, '..', 'sample', 'src'
        dest: path.join __dirname, '..', 'sample', 'public'
      req =
        url: 'http://localhost/script.js'
        method: 'GET'
      res = {}
      (connectCommonJsAmd options) req, res, ->
        content = fs.readFileSync(
          path.join(
            __dirname,
            '..',
            'sample',
            'public',
            'script.js'
          ),
          'utf8'
        )

        expectedCode = fs.readFileSync(
          path.join(
            __dirname,
            '..',
            'sample',
            'expected.js'
          ),
          'utf8'
        )

        debug 'The expected code:\n%s', expectedCode
        debug 'The actual code: \n%s', content
        expect(content).to.be(expectedCode)
        done()
