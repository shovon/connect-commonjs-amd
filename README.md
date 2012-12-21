# connect-commonjs-amd

A connect middleware, to help you write front-end JavaScript in CommonJS, but run it as AMD modules.

## Installation

It's a simple npm module, so you can either install it using npm,

```shell
$ npm install connect-commonjs-amd
```

or, you can add it to your `package.json` file.

## Usage

This middleware works by determining if a requested file even exists. If it doesn't, then it will look for it in another directory that you specify.

I am going to assume that you have all your source JavaScript file in a `./src` directory, and you want the outputed JavaScript to be stord in the `./public` directory.

```javascript
var express = require('express')
  , path = require('path')
  , app = express()
  , publicFolder = path.join(__dirname, 'public');

app.use(require('connect-commonjs-amd')({
    src: path.join(__dirname, 'src')
  , dest: path.join(__dirname, 'public')
}));

app.use(express.static(publicFolder));

app.listen(3000);

console.log("Server listening on port 3000");
```

So everytime a user requests a `js/script.js`, and the middleware isn't able to find it in `./public/js`, then it will look in `./src/js`. If it finds it there, it will then wrap the JavaScript with a define call, and then save it in `./public/js`.

If you want to try it out, here's how. I'm going to assume that your source tree looks like so.

* *project-directory/*
    * *server.js* (the above server code)
    * *package.json*
    * *public/*
        * *index.html*
        * *js/*
            * *require.js* (assuming that you use RequireJS as the AMD loader)
    * *src/*
        * *app/*
            * *foo.js*
            * *script.js*

Here's what your `public/index.html` might look like.

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>My App</title>
  </head>
  <script type="text/javascript" src="js/require.js"></script>
  <script type="text/javascript">
  require(['app/script'], function () {
    var script = require('script');
    script.init();
  });
  </script>
</html>
```

And perhaps your `public/src/app/script.js` might look like this.

```javascript
var foo = require('app/foo');

module.exports.init = function () {
  alert(foo.greeting);
};
```

And your `public/src/app/foo.js` might look like this.

```javascript
module.exports.greeting = "Hello, World!";
```

Start your server and go to your browser. You should see an alert box show with the string "Hello, World!".

You can find a slightly modified version of the above example, [here](https://github.com/shovon/connect-commonjs-amd/tree/master/test-server).

## API

### `toCommonJs`

`connect-commonjs-amd` has one function that you can call without using the module as a middleware. `toCommonjs` is that function.

```javascript
var connectCommonJsAmd = require('connect-commonjs-amd')
  , sourceCode = 'console.log("Hello, World!");'

connectCommonJsAmd.toCommonJs(sourceCode);
```

## What about CoffeeScript?

You can use this module's `toCommonJs` function, in conjunction with the <a href="https://github.com/wdavidw/node-connect-coffee-script" target="_blank">`connect-coffee-script`</a> module.

```javascript
var express = require('express')
  , path = require('path')
  , connectCommonJsAmd = require('connect-commonjs-amd')
  , port = process.argv[2] || 3000
  , publicFolder = path.join(__dirname, 'public')
  , server = express()
  , srcFolder = path.join(__dirname, 'src');

server.configure(function() {
  server.use(express.bodyParser());
  server.use(express.methodOverride());

  // Convert all your CommonJS CoffeeScript to AMD.
  server.use(require('connect-coffee-script')({
      src: srcFolder
    , dest: publicFolder
    , compile: function (str, options) {
      options.bare = true;
      code = CoffeeScript.compile(str, options);
      // Here's the call to `toCommonJs`.
      return connectCommonJsAmd.toCommonJs(code);
    }
  }));
  server.use(express["static"](publicFolder));

  server.use(express.errorHandler({
    dumpException: true,
    showStack: true
  }));
  server.use(server.router);
});

server.listen(port);

console.log("Server listening on port " + port);

```

## Development

### Testing

Mocha is used for the testing suite. And, you can run the test using the following command.

```shell
$ npm test
```

Or you can use the `mocha` command. Both the same thing.