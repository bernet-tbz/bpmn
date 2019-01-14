var express = require('express');
var app = express();

app.set('view engine', 'ejs')


//Cookie Parser
var cookieParser = require('cookie-parser')
app.use(cookieParser());

//Initialize
var fs = require('fs');
var path = require('path');
var querystring = require('querystring');
var session = require('express-session');
var bodyParser = require('body-parser');

var async = require('async');

var urlencodedParser = bodyParser.urlencoded({
  extended: false
});

app.set('views', path.join(__dirname, '/views'));

//Manage Requested Static Files
app.use('/assets', express.static('assets'));
app.use('/data', express.static('data'));

//Manage Routes
app.get('/', function(req, res) {
  res.render('index');
});

//Manage Routes
app.get('/form', function(req, res) {
  res.render('index');
});

//The 404 Route
app.get('*', function(req, res) {
  res.status(404);
  res.render('404');
});

//WEBSOCKET & SERVER
var server = require('http').createServer(app);
var io = require('socket.io').listen(server);
var users;
users = [];
var connections
connections = [];

server.listen(process.env.PORT || 8787);
console.log('Server started. Listening on Port 8787')