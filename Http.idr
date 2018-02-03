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

export
partial
httpServer : Nat -> Event (Request, Response)
httpServer port =
    let serv = (jscall """(function() {
              var server = http.createServer();
              server.listen(%0)
              return server
            })()"""
            (Int -> JS_IO Ptr)
            (cast port))
    in let singlified = map (singlifyNativeEvent Node) serv
    in ptrToEvent {to=(Ptr, Ptr)} Node singlified "request"
      
splitPath : String -> List String
splitPath = filter (\p => p /= "") . split (\c => c == '/')

export
write : Response -> String -> JS_IO ()
write = jscall "%0.end(%1)" (Ptr -> String -> JS_IO ()) 

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





