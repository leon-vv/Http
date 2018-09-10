{- This Source Code Form is subject to the terms of the Mozilla Public
 - License, v. 2.0. If a copy of the MPL was not distributed with this
 - file, You can obtain one at http://mozilla.org/MPL/2.0/. -}

module Http

import Event

import Record

import FerryJS
import FerryJS.Util

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

||| Return an Ht
export
httpServer : Nat -> HttpServer
httpServer port =
  (unsafePerformIO $
    (jscall "http.createServer()"
    (JS_IO Ptr)))
      `MkPair` port
      
export
partial
listen : HttpServer -> Event Multiple (Request, Response)
listen (server, port) =
  let listenIO = jscall "%0.listen(%1)" (Ptr -> Int -> JS_IO ()) server (cast port)
  in let ptrIO = listenIO *> pure server
  in let singlified = map (singlifyNativeEvent Node) ptrIO
  in ptrToEvent {to=(Ptr, Ptr)} Node singlified "request"


splitPath : String -> List String
splitPath = filter (\p => p /= "") . split (\c => c == '/')

||| Write the string to Response and close the connection.
export
write : Response -> String -> JS_IO ()
write = jscall "%0.end(%1)" (Ptr -> String -> JS_IO ()) 

export
setHeader : Response -> String -> String -> JS_IO ()
setHeader = jscall "%0.setHeader(%1, %2)" (Ptr -> String -> String -> JS_IO ())

export
setStatusCode : Response -> Nat -> JS_IO ()
setStatusCode res code =
  jscall "%0.statusCode = %1" (Ptr -> Int -> JS_IO()) res (cast code)

export
getUrl : Request -> Url
getUrl = unsafePerformIO . jscall "url.parse(%0.url)" (Ptr -> JS_IO Ptr)

export
getPath : Url -> List String
getPath = splitPath .
            unsafePerformIO .
            jscall "%0.pathname" (Ptr -> JS_IO String)

export
getQuery : Url -> String
getQuery = unsafePerformIO . jscall "%0.query" (Ptr -> JS_IO String)

||| Try to convert the query part of the URL to the given record.
export
getQueryAs : {auto ti: ToIdris (Record sch)} -> Url -> Maybe (Record sch)
getQueryAs {ti} {sch} url =
  unsafePerformIO $
    toIdris {ti=ti} {to=Record sch} <$>
      jscall "querystring.parse(%0)" (String -> JS_IO Ptr) (getQuery url)



