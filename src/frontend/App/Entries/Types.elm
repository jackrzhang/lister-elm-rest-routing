module App.Entries.Types exposing (..)

import Http

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
    = HttpError Http.Error
    | FetchAllSuccess (List Entry)
    | AddEntrySuccess Entry
    | RemoveEntrySuccess Int
    | ToggleCompleteSuccess Int


type CmdMsg
    = FetchAll
    | AddEntry String
    | RemoveEntry Int
    | ToggleComplete Int
