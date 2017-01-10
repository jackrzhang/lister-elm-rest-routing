module App.State exposing (..)

import Navigation exposing (Location)

import App.Types exposing (..)
import App.Input.State as Input
import App.Entries.State as Entries
import App.Control.State as Control


-- INIT

init : Location -> ( Model, Cmd Msg )
init location =
    initialModel ! []


initialModel : Model
initialModel =
    { input = Input.initialModel
    , entries = Entries.initialModel
    , control = Control.initialModel
    }


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        NoOp ->
            model ! []

        UrlChange location ->
            model ! []

        LinkClick path ->
            let cmd =
                Navigation.newUrl path
            in
                model ! [ cmd ]
        
        ChainMsgs msgs ->
            (List.foldl chain (model ! []) msgs)

        MsgForInput inputMsg ->
            { model | input = Input.updateModel inputMsg model.input}
                ! []

        MsgForEntries entriesMsg ->
            { model | entries = Entries.updateModel entriesMsg model.entries }
                ! []

        MsgForControl controlMsg ->
            { model | control = Control.updateModel controlMsg model.control }
                ! []


chain : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
chain msg ( model, cmd ) =
    let ( nextModel, nextCmd ) =
        update msg model
    in
        nextModel ! [ cmd, nextCmd ]
