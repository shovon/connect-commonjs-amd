define(['foo', 'something'], function () {
var module = { exports: {} }
  , exports = module.exports;

(function () {

var foo = require('foo')
  , something = require('something');

module.exports.another = function () {
  return foo.another(something);
};

})();

return module.exports;
});