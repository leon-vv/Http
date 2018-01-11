import Event
import Record
import FerryJS

%include Node "http/runtime.js"

export
Request : Type
Request = Ptr

export
Response : Type
Response = Ptr 
export
httpServer : JS_IO (Event (Request, Response))
httpServer = do
    serverEvent <- Event.JS.fromGeneratorString {sch=[("request", Ptr), ("response", Ptr)]} "httpServer"
    pure (map (\r => (r .. "request", r .. "response")) serverEvent)
      
export
write : Response -> String -> JS_IO ()
write = jscall "%0.end(%1)" (JSRef -> String -> JS_IO ()) 

export
getUrl : Request -> JS_IO String
getUrl = jscall "%0.url" (JSRef -> JS_IO String)

