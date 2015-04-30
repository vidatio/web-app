/**
 * Server of vidatio website
 * @license MIT
 */

var express = require('express');
var request = require('request');
var app = express();

// Allow the app read any file from an external server
// CORS and SOP forces this server to implement this proxy endpoint
app.use('/', function(req, res) {
  var url = req.query.url;
  req.pipe(request(url)).pipe(res);
});

var port = 5000;
app.listen(port, function () {
  console.log("Listening on port", port, "...");
});