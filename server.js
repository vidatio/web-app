/**
 * Server of vidatio website
 * @license MIT
 */

var express = require('express');
var app = express();

//Add directory for file lockup
app.use(express.static(__dirname + '/'));

//Response get on root with main index.html
app.get('/', function (req, res) {
  res.sendfile('./app/index.html');
});

var port = 5000;
app.listen(port, function () {
  console.log("Listening on port", port, "...");
});