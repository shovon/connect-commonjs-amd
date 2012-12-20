define(['app/message'], function () {
var module = { exports: {} };

var message = require('app/message');
module.exports = {
  init: function () {
    console.log(message.message);
  }
};

return module.exports;
});