define(['foo', 'something'], function () {
var module = { exports: {} };

var foo = require('foo')
  , something = require('something');

module.exports.another = function () {
  return foo.another(something);
};

return module.exports;
});