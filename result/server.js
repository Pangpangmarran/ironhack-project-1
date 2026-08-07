var express = require('express'),
    async = require('async'),
    { Pool } = require('pg'),
    cookieParser = require('cookie-parser'),
    path = require('path'),
    app = express(),
    server = require('http').Server(app);

var io = require('socket.io')(server);
var port = process.env.PORT || 4000;

// Default Socket.IO connection
io.on('connection', function (socket) {
  console.log("Connected to Socket.IO");
  socket.emit('message', { text: 'Welcome!' });  
  socket.on('subscribe', function (data) {
    socket.join(data.channel);
  });
});

server.listen(port, function () {
  console.log('App running on port ' + server.address().port);
});

var pgHost = process.env.PG_HOST || 'db';
var pgPort = process.env.PG_PORT || 5432;
var pgUser = process.env.PG_USER || 'postgres';
var pgPassword = process.env.PG_PASSWORD || 'postgres';
var pgDatabase = process.env.PG_DATABASE || 'votes';

var connectionString = `postgresql://${pgUser}:${pgPassword}@${pgHost}:${pgPort}/${pgDatabase}`;
console.log("Connection string:", connectionString);  // ADD THIS LINE
console.log(connectionString);

var { Pool } = require('pg');
var pool = new Pool({ connectionString: connectionString });

async.retry(
  { times: 1000, interval: 1000 },
  function (callback) {
    pool.connect(function (err, client, done) {
      if (err) {
        console.error("Waiting for db");
      }
      callback(err, client);
    });
  },
  function (err, client) {
    if (err) {
      return console.error("Giving up");
    }
    console.log("Connected to db");
    getVotes(client);
  }
);

function getVotes(client) {
  console.log("getVotes() called");  
  client.query('SELECT vote, COUNT(id) AS count FROM votes GROUP BY vote', [], function (err, result) {
    console.log("Query callback fired, err:", err);  
    if (err) {
      console.error("Error performing query: " + err);
    } else {
      var votes = collectVotesFromResult(result);
      console.log("Emitting scores:", JSON.stringify(votes)); 
      io.emit("scores", JSON.stringify(votes));
    }
    setTimeout(function () { getVotes(client); }, 1000);
  });
}

function collectVotesFromResult(result) {
  var votes = { a: 0, b: 0 };
  console.log("Raw query result:", result.rows);  
  result.rows.forEach(function (row) {
    console.log("Processing row:", row.vote, "count:", row.count);  
    votes[row.vote] = parseInt(row.count);
  });
  console.log("Final votes object:", votes);  
  return votes;
}

app.use(cookieParser());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'views')));
app.use("/result", express.static(path.join(__dirname, 'views')));

app.get(['/', '/result'], function (req, res) {
  res.sendFile(path.resolve(__dirname, 'views', 'index.html'));
});

