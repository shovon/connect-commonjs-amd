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

app.use(express.static(public));

app.listen(3000);

console.log("Server listening on port 3000");
```

So everytime a user requests a `js/script.js`, and the middleware isn't able to find it in `./public/js`, then it will look in `./src/js`. If it finds it, it will then wrap the `.js` file with a define call.

## Development

### Testing

Mocha is used for the testing suite. And, you can run the test using the following command.

```shell
$ npm test
```

Or you can use the `mocha` command. Both the same thing.