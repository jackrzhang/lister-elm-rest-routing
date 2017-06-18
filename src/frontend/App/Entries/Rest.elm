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
    Http.send removeEntryResponse (deleteEntry id)


toggleComplete : Entry -> Cmd App.Msg
toggleComplete entry =
    let updatedEntry =
        { entry | complete = not entry.complete }
    in
        Http.send toggleCompleteResponse (putEntry updatedEntry)


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


removeEntryResponse : Result Error Int -> App.Msg
removeEntryResponse result =
    RemoveEntryResponse result
        |> Entries.MsgForModel
        |> App.MsgForEntries


toggleCompleteResponse : Result Error Entry -> App.Msg
toggleCompleteResponse entry =
    ToggleCompleteResponse entry
        |> Entries.MsgForModel
        |> App.MsgForEntries


-- REQUESTS

getEntries : Http.Request (List Entry)
getEntries =
    Http.get entriesUrl entriesDecoder


postEntry : String -> Http.Request Entry
postEntry text =
     Http.post entriesUrl (Http.jsonBody (entryEncoder text False)) entryDecoder


deleteEntry : Int -> Http.Request Int
deleteEntry id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = entryUrl id
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (\_ -> Ok id)
        , timeout = Nothing
        , withCredentials = False
        }


putEntry : Entry -> Http.Request Entry
putEntry { id, text, complete } =
    Http.request
        { method = "PUT"
        , headers = []
        , url = entryUrl id
        , body = Http.jsonBody (entryEncoder text complete)
        , expect = Http.expectJson entryDecoder
        , timeout = Nothing
        , withCredentials = False
        }


-- RESOURCES

entriesUrl : String
entriesUrl =
    "/api/entries"


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


