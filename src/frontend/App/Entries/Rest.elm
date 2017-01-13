module App.Entries.Rest exposing (..)

import Http exposing (Error)
import Json.Decode as Decode
import Json.Encode as Encode

import App.Types as App
import App.Entries.Types as Entries exposing (..)


-- COMMANDS

fetchAll : Cmd App.Msg
fetchAll =
    Http.send fetchAllResponse getEntries


addEntry : String -> Cmd App.Msg
addEntry text =
    Http.send addEntryResponse (postEntry text)


removeEntry : Int -> Cmd App.Msg
removeEntry id =
    Cmd.none


toggleComplete : Int -> Cmd App.Msg
toggleComplete id =
    Cmd.none


-- MSG CONTAINERS

fetchAllResponse : Result Error (List Entry) -> App.Msg
fetchAllResponse result =
    FetchAllResponse result
        |> Entries.MsgForModel
        |> App.MsgForEntries


addEntryResponse : Result Error Entry -> App.Msg
addEntryResponse result =
    AddEntryResponse result
        |> Entries.MsgForModel
        |> App.MsgForEntries


-- REQUESTS

getEntries : Http.Request (List Entry)
getEntries =
    Http.get entriesUrl entriesDecoder


postEntry : String -> Http.Request Entry
postEntry text =
     Http.post entriesUrl (Http.jsonBody (entryEncoder text False)) entryDecoder


-- RESOURCES

entriesUrl : String
entriesUrl =
    "http://localhost:3000/api/entries"


entryUrl : Int -> String
entryUrl id =
    String.join "/" [ entriesUrl, (toString id) ]


-- DECODERS

entriesDecoder : Decode.Decoder (List Entry)
entriesDecoder =
    Decode.list entryDecoder


entryDecoder : Decode.Decoder Entry
entryDecoder =
    Decode.map3 Entry
        (Decode.field "id" Decode.int)
        (Decode.field "text" Decode.string)
        (Decode.field "complete" Decode.bool)


-- ENCODERS

entryEncoder : String -> Bool -> Encode.Value
entryEncoder text complete =
    Encode.object
        [ ( "text", Encode.string text )
        , ( "complete", Encode.bool complete )
        ]


