import Http
import Event
import Html

import Record.JS

page : Html
page = tagc "html" [tag "head", tagc "body" [text "Some text"]]

State : Type
State = Event (Request, Response)

initialState : JS_IO State
initialState = httpServer

nextState : State -> JS_IO State
nextState httpServer = do
  maybeReq <- httpServer
  (case maybeReq of
       Just (req, res) => do
         url <- getUrl req
         Record.JS.log url
         write res (show page)
       Nothing => pure ())
  pure httpServer

main : JS_IO ()
main = run initialState nextState
