module App.Entries.Rest exposing (..)

import Http
import Task
import Json.Decode as Decode
import Json.Encode as Encode

import App.Entries.Types as Entries exposing (..)


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
        (field "id" Decode.int)
        (field "text" Decode.string)
        (field "complete" Decode.bool)


-- ENCODERS

entryEncoder : Int -> String -> Bool -> Encode.Value
entryEncoder id text complete =
    let fields =
        [ ( "id", id )
        , ( "text", text )
        , ( "complete", complete )
        ]
    in
        fields
            |> Encode.object


-- COMMANDS

