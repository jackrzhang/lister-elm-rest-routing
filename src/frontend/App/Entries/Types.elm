module App.Entries.Types exposing (..)

import Http exposing (Error)

import App.Control.Types exposing (Filter)


-- MODEL

type alias Entry =
    { id : Int
    , text : String
    , complete : Bool
    }


type alias Model =
    { list : List Entry
    , filter : Filter
    , currentId : Int
    }


-- MSG

type Msg
    = MsgForModel ModelMsg
    | MsgForCmd CmdMsg


type ModelMsg
    = FetchAllResponse (Result Error (List Entry))
    | AddEntryResponse (Result Error Entry)
    | RemoveEntryResponse (Result Error Int)
    | ToggleCompleteResponse (Result Error Entry)


type CmdMsg
    = FetchAllRequest
    | AddEntryRequest String
    | RemoveEntryRequest Int
    | ToggleCompleteRequest Entry
