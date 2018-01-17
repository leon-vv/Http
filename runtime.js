const http = require('http')
const url = require('url')
const queryString = require('query-string')

var httpServer = eventGenerator(function(cb) {

    var argumentsToObject = function(req, res) {
        cb({
            "request": req,
            "response": res
        });
    }

    http.createServer(argumentsToObject).listen(3000, (err) => {
        if(err) {
            console.log("Node HTTP Server error: ", err)
        }
    });
});
