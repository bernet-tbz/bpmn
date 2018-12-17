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

//Session Function
app.use(session({
  secret: 'keyboard cat',
  cookie: {
    maxAge: 2 * 60 * 60 * 1000 // expires after 2 hours
  }
}));

//Validation Functions
function validateEmail(email) {
  var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  return re.test(email)
}

//Check if Object has contents
function isEmptyObject(obj) {
  return !Object.keys(obj).length;
}

//Function to Check if User is logged in
function isLoggedIn(req, res, next) {
  if (req.session.authenticated === true) {
    next();
  } else {
    res.redirect('/login');
  }
}

//DB Connection
var db = require('./db');
var con = db.con;

//Manage Requested Static Files
app.use('/assets', express.static('assets'));
app.use('/data', express.static('data'));

//Manage Routes
app.get('/', isLoggedIn, function(req, res) {
  var sess = req.session;
  res.render('index', {
    session: sess
  });
});

//### Encryption
var bcrypt = require('bcrypt');
//###

app.get('/register', function(req, res) {
  res.render('register', {
    errors: '',
    username: '',
    email: '',
    password: '',
    password_repeat: ''
  });
});

app.post('/register', urlencodedParser, function(req, res) {
  var msg = '';
  var state = true;
  var password, password_repeat, email, username;

  if (req.body.username && req.body.password && req.body.email) {
    //VARS
    username = querystring.escape(req.body.username);
    email = req.body.email;
    password = querystring.escape(req.body.password);
    password_repeat = querystring.escape(req.body.password_repeat);

    //Username Check
    if (username.length >= 3) {} else {
      msg += "username needs to be at least 3 characters long! "
      state = false;
    }

    //E-Mail Check
    if (validateEmail(email) == false) {
      msg += "e-mail address has an invalid format!"
      state = false;
    }

    //Password Check
    if (password.length >= 4) {
      if (password_repeat == password) {
        //Everthing OK
      } else {
        msg += "the passwords don't match! "
        state = false;
      }
    } else {
      msg += "the password has to be at least 4 characters long! "
      state = false;
    }
  } else {
    msg += "some fields are empty! "
    state = false;
  }

  //Encrypt Password
  var salt = bcrypt.genSaltSync(10);
  var hash = bcrypt.hashSync(password, salt);

  //Wenn Status = True
  if (state == true) {
    //Try to Register User
    var sql_query = 'CALL insert_user("' + username + '", "' + hash + '", "' + email + '")'

    msg += 'Successfully registered! You can now log in.';
    feedback = '<div class="card-panel indigo lighten-4 center">' + msg + '</div>';

    if (msg = '') {
      feedback = '';
    }

    res.render('register', {
      errors: feedback,
      username: '',
      email: '',
      password: '',
      password_repeat: ''
    });

    /* Enabled Registration: */
    db.executeQuery(sql_query, function(val) {
      var data_row = val[0][0] // erste Zeile der data row
      var data_row = val[0] // odbc version..
      //var stored_procedure_row = val[1]

      var last_id = data_row.last_id
      var feedback = ''

      if (last_id == 0) {
        // no new row added in db
        console.log('user already registered')

        msg += 'User already registered. Try a different username/email.';
        feedback = '<div class="card-panel red lighten-4 center">' + msg + '</div>';
      } else {
        // user registered
        msg += 'Successfully registered! You can now log in.';
        feedback = '<div class="card-panel indigo lighten-4 center">' + msg + '</div>';
      }

      if (msg = '') {
        feedback = '';
      }

      res.render('register', {
        errors: feedback,
        username: '',
        email: '',
        password: '',
        password_repeat: ''
      });
    });

  } else {
    var feedback = '<div class="card-panel red lighten-4 center">' + msg + '</div>';

    if (msg = '') {
      feedback = '';
    }

    res.render('register', {
      errors: feedback,
      username: username,
      email: email,
      password: password,
      password_repeat: password_repeat
    });
  }
});

app.get('/login', function(req, res) {
  res.render('login', {
    errors: ''
  });
});

app.post('/login', urlencodedParser, function(req, res) {
  var sess = req.session
  sess.authenticated = false;

  if (req.body.username && req.body.password) {
    //VARS
    var username = querystring.escape(req.body.username);
    var password = querystring.escape(req.body.password);

    console.log('Logging In: ' + username);

    var sql_query = 'CALL select_user_by_name("' + username + '")';
    db.executeQuery(sql_query, function(val) {
      var data_row = val[0][0]
      //var stored_procedure_row = val[1]
      console.log('login db response: ' + JSON.stringify(val))

      if (data_row == undefined) {
        //No Result in DB
        console.log('Account doesnt exist.');
        res.render('login', {
          errors: '<div class="card-panel red lighten-4 center">This account doesnt exist!</div>'
        });
      } else {
        //Account found
        var hash = data_row.password;
        if (bcrypt.compareSync(password, hash)) {
          sess.authenticated = true;

          sess.username = data_row.username;
          sess.userid = data_row.id;

          //Create Cookie for later Access
          res.cookie('user', sess.username, {
            maxAge: 900000,
            httpOnly: true
          });

          console.log('User signed in.' + sess.authenticated);
          res.redirect('/');
        } else {
          res.render('login', {
            errors: '<div class="card-panel red lighten-4 center">Wrong password!</div>'
          });
        }
      }
    });
  } else {
    //Not all Parameters Given / False
    res.render('login', {
      errors: '<div class="card-panel red lighten-4 center">Invalid login credentials!</div>'
    });
  }
});

app.get('/logout', function(req, res) {
  var sess = req.session

  sess.authenticated = false;
  sess.username = null;
  sess.userid = null;

  console.log('After Logout: ' + req.session.authenticated);
  res.redirect('/login');
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
console.log('Server started. Listening on Port 8888')