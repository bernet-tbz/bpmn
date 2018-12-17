var http = require("http");
var https = require("https");

var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
var xhr = new XMLHttpRequest();

/**
 * getJSON:  REST get request returning JSON object(s)
 * @param options: http options object
 * @param callback: callback to pass the results JSON object(s) back
 */
exports.getJSON = function(options, onResult)
{
    console.log("rest::getJSON");

    var port = options.port == 443 ? https : http;
    var req = port.request(options, function(res)
    {
        var output = '';
        console.log(options.host + ':' + res.statusCode);
        res.setEncoding('utf8');

        res.on('data', function (chunk) {
            output += chunk;
        });

        res.on('end', function() {
            console.log(output);
            var obj = JSON.parse(output);
            onResult(res.statusCode, obj);
        });
    });

    req.on('error', function(err) {
        //res.send('error: ' + err.message);
    });

    req.end();
};

const hostname = 'http://109.230.227.9:8081'


exports.JSON = function(route, payload, callback) {
  const xhr = new XMLHttpRequest()
  xhr.open("POST", hostname + route, true)

  console.log(hostname + route);

  xhr.setRequestHeader('Content-Type', "application/json");
  xhr.addEventListener("load", () => {
    console.log(xhr.responseText)
    callback(JSON.parse(xhr.responseText, xhr))
  })

  console.log('sending: ' + payload)
  xhr.send(JSON.stringify(payload))
};

exports.POST = function(route, payload, callback) {
  const xhr = new XMLHttpRequest();
  xhr.open("POST", hostname + route, true);

  xhr.setRequestHeader('Content-Type', 'form-data');
  xhr.addEventListener("load", () => {
    callback(xhr.responseText)
  });

  xhr.send(payload);
};

exports.POST2 = function(route, payload, callback){
  const xhr = new XMLHttpRequest();
  xhr.open("POST", 'http://109.230.227.9:8081/api/login', true);

  //Send the proper header information along with the request
  xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

  /*hr.onreadystatechange = function() {//Call a function when the state changes.
      //console.log('response: ' + xhr.responseText)
      if(xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
        console.log(xhr.responseText)
        // Request finished. Do processing here.
      }
  }*/

  xhr.addEventListener("load", () => {
    console.log('event called')
    console.log(xhr.responseText)
  });

  xhr.send("username=root&password=1234");
}

exports.GET = function(route, callback) {
  const xhr = new XMLHttpRequest();
  xhr.open("GET", hostname + route, true);

  xhr.addEventListener("load", () => {
    callback(JSON.parse(xhr.responseText, xhr))
  })

  xhr.send()
};
