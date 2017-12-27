import Event

import Record
import Record.JS

import IdrisScript

%include Node "Http/runtime.js"

export
Request : Type
Request = JSRef

export
Response : Type
Response = JSRef

export
httpServer : Event (Request, Response)
httpServer = map 
                (\r => (r .. "request", r .. "response"))
                (Event.JS.fromString {sch=[("request", JSRef), ("response", JSRef)]} "httpServer")

export
write : Response -> String -> JS_IO ()
write = jscall "%0.end(%1)" (JSRef -> String -> JS_IO ()) 

export
getUrl : Request -> JS_IO String
getUrl = jscall "%0.url" (JSRef -> JS_IO String)

