import Event
import Record
import FerryJS
import Html

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
httpServer : JS_IO (Event (Request, Response))
httpServer = do
    serverEvent <- Event.JS.fromGeneratorString {sch=[("request", Ptr), ("response", Ptr)]} "httpServer"
    pure (map (\r => (r .. "request", r .. "response")) serverEvent)
      
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
getSearchAs : {auto fjs: FromJS (Record sch)} -> Url -> Maybe (Record sch)
getSearchAs {fjs} {sch} url = unsafePerformIO $
    Functor.map
      (\ptr => fromJS {fjs=fjs} {to=Record sch} ptr)
      (jscall "queryString.parse(%0)" (String -> JS_IO Ptr) (getSearch url))











