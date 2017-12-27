const http = require('http')

var httpServer = new Event(function(cb) {

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
