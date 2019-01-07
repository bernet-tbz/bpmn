var mysql = require('mysql');

// load environment variables
require('dotenv').config({path: './env.list'})

var con = mysql.createConnection({
  host: process.env.DATABASE_HOST,
  port: '3306',
  user: 'root',
  password: process.env.DB_PASSWORD
});

con.connect(function(err) {
  if (err) throw err;
  console.log('Connected!');
});

function executeQuery(sql, callback){
  var result = con.query(sql, function (err, res) {
      if (err){
        if (err.code === 'ER_DUP_ENTRY') {
          console.log('Entry already exists! UNIQUE_KEY');
        } else {
          throw err;
        }
      }

      callback(res); //Call Given function with result
  });
}

con.query('USE stream_dream5;', function (err, result) {
    if (err) throw err;
    console.log('Using database');
});

module.exports = {
  con: con,
  executeQuery: executeQuery,
  escape: mysql.escape
};