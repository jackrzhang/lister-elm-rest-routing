module App.State exposing (..)

import Navigation exposing (..)

import App.Types exposing (..)
import App.Control.Types as Control exposing (Filter(..))
import App.Routes as Routes

import App.Input.State as Input
import App.Entries.State as Entries
import App.Control.State as Control


-- INIT

init : Location -> ( Model, Cmd Msg )
init location =
    (locationToModel location initialModel) ! []


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
            (locationToModel location model) ! []

        NavigateTo route ->
            model ! [ Navigation.newUrl (Routes.routeToPath route) ]
        
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


-- HELPERS

locationToModel : Location -> Model -> Model
locationToModel location model =
    let 
        route =
            Routes.pathParser location
                |> Maybe.withDefault Routes.All

        filter =
            case route of
                Routes.All -> All
                Routes.Active -> Active
                Routes.Complete -> Complete

        entriesModel = model.entries
        controlModel = model.control

        entries =
            { entriesModel | filter = filter }

        control =
            { controlModel | filter = filter }

    in
        { model 
            | entries = entries
            , control = control
        }


chain : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
chain msg ( model, cmd ) =
    let ( nextModel, nextCmd ) =
        update msg model
    in
        nextModel ! [ cmd, nextCmd ]
