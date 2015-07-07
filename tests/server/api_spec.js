var frisby = require("frisby");

/**
 * IMPORTANT: app.js has to be started before executing this test
 */
var urlExample = "https://encrypted.google.com/robots.txt";
frisby.create("Read example file for client by link")
  .get("http://localhost:5000/api?url=" + urlExample)
  .expectStatus(200)
  .expectHeaderContains("Content-Type", "text/plain")
  .expectBodyContains("User-agent: *")
.toss();