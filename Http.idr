import Event

import Record
import FerryJS

%include Node "http/runtime.js"

%default total

export
Request : Type
Request = Ptr

export
Response : Type
Response = Ptr 

export
Url : Type
Url = Ptr

-- Server pointer and port.
-- Port cannot be made an argument
-- of the listen function.
-- This will break if listen is called 
-- twice with two different port numbers
-- because the server object does not change.
export
HttpServer : Type
HttpServer = (Ptr, Nat) 

export
httpServer : Nat -> HttpServer
httpServer port =
  (unsafePerformIO $
    (jscall "http.createServer()"
    (JS_IO Ptr)), port)
      
export
partial
listen : HttpServer -> Event (Request, Response)
listen (server, port) =
  let listenIO = jscall "%0.listen(%1)" (Ptr -> Int -> JS_IO ()) server (cast port)
  in let ptrIO = listenIO *> pure server
  in let singlified = map (singlifyNativeEvent Node) ptrIO
  in ptrToEvent {to=(Ptr, Ptr)} Node singlified "request"


splitPath : String -> List String
splitPath = filter (\p => p /= "") . split (\c => c == '/')

export
write : Response -> String -> JS_IO ()
write = jscall "%0.end(%1)" (Ptr -> String -> JS_IO ()) 

export
setHeader : Response -> String -> String -> JS_IO ()
setHeader = jscall "%0.setHeader(%1, %2)" (Ptr -> String -> String -> JS_IO ())

export
getUrl : Request -> Url
getUrl = unsafePerformIO . jscall "url.parse(%0.url)" (Ptr -> JS_IO Ptr)

export
getPath : Url -> List String
getPath = splitPath .
            unsafePerformIO .
            jscall "%0.pathname" (Ptr -> JS_IO String)

export
getSearch : Url -> String
getSearch = unsafePerformIO . jscall "%0.search" (Ptr -> JS_IO String)

export
getSearchAs : {auto ti: ToIdris (Record sch)} -> Url -> Maybe (Record sch)
getSearchAs {ti} {sch} url = unsafePerformIO $
    Functor.map
      (\ptr => toIdris {ti=ti} {to=Record sch} ptr)
      (jscall "queryString.parse(%0)" (String -> JS_IO Ptr) (getSearch url))





