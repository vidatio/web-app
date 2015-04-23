/**
 * Server of vidatio website
 * @license MIT
 */

var express = require('express');
var request = require('request');
var app = express();


// allow CORS to allow requests from other hosts and ports (e.g. localhost:49000)
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

// Allow the app read any file from an external server
// CORS and SOP forces this server to implement this proxy endpoint
app.use('/api', function(req, res) {
  var url = req.query.url;
  req.pipe(request(url)).pipe(res);
});

var port = 5000;
app.listen(port, function () {
  console.log("Listening on port", port, "...");
});