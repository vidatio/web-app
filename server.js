var express = require('express');
var app = express();

app.use(express.static(__dirname + '/'));
app.use('/bower_components', express.static(__dirname + '/bower_components'));

app.get('/', function (req, res) {
  res.sendfile('./app/index.html');
});

var port = 5000;
app.listen(port, function () {
  console.log("Listening on port", port, "...");
});