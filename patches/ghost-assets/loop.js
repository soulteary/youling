const http = require("http");

const server = http.createServer(function(req, res) {
  res.writeHead(200);
  res.end("Hold on for sync assets");
});

server.listen(2368);
