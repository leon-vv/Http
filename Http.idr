import Event

import Record
import Record.JS

import IdrisScript

%include Node "runtime.js"

export
httpServer_ : JS_IO JSRef
httpServer_ = jscall "httpServer.getValue()" (JS_IO JSRef)

export
Request : Type
Request = JSRef

export
Response : Type
Response = JSRef

export
httpServer : Event (Request, Response)
httpServer = ioToEvent {schema=[("request", JSRef), ("response", JSRef)]} 
                httpServer_
                (\r => (r .. "request", r .. "response"))

export
write : Response -> String -> JS_IO ()
write = jscall "%0.end(%1)" (JSRef -> String -> JS_IO ()) 

export
getUrl : Request -> JS_IO String
getUrl = jscall "%0.url" (JSRef -> JS_IO String)

