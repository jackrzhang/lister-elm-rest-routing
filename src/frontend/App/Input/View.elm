module App.Input.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Utility.OnEnter exposing (onEnter)

import App.Types as App
import App.Input.Types as Input
import App.Entries.Types as Entries


view : Input.Model -> Html App.Msg
view model =
    div [ class "input" ]
        [ span [ class "caret" ] [ text "❯ " ]
        , input
            [ type_ "text"
            , placeholder "write stuff, hit enter"
            , autofocus True
            , value model.text
            , onInput (App.MsgForInput << Input.UpdateInput)
                -- equivalent to: (\str -> App.MsgForInput (Input.UpdateInput str))
            , onEnter (enterInput model)
            ]
            []
        ]


enterInput : Input.Model -> App.Msg
enterInput model =
    if model.text == "" then
        App.NoOp
    else 
        App.ChainMsgs
            [ (addEntry model)
            , (App.MsgForInput Input.ClearInput)
            ]


addEntry : Input.Model -> App.Msg
addEntry model =
    Entries.AddEntry model.text
        |> Entries.MsgForCmd
        |> App.MsgForEntries