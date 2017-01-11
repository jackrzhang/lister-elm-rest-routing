module App.Entries.State exposing (..)

import App.Types as App
import App.Entries.Types exposing (..)
import App.Control.Types exposing (Filter(..))


-- INIT

initialModel : Model
initialModel =
    { list = []
    , filter = All
    , currentId = 0
    }


-- UPDATE

update : Msg -> Model -> ( Model, Cmd App.Msg )
update msg model =
    case msg of
        MsgForModel modelMsg ->
            ( updateModel modelMsg model, Cmd.none )

        MsgForCmd cmdMsg ->
            ( model, updateCmd cmdMsg model )


updateModel : ModelMsg -> Model -> Model
updateModel modelMsg model =
    case modelMsg of
        HttpError _ ->
            model

        FetchAllSuccess entries ->
            model

        AddEntrySuccess entry ->
            model
            --{ model 
            --    | list = List.append model.list [ Entry model.currentId text False ]
            --    , currentId = model.currentId + 1
            --}

        RemoveEntrySuccess id ->
            model
            --{ model | list = List.filter (\entry -> not <| entry.id == id) model.list }

        ToggleCompleteSuccess id ->
            model
            --{ model | list = toggleComplete id model.list }


updateCmd : CmdMsg -> Model -> Cmd App.Msg
updateCmd cmdMsg model =
    case cmdMsg of
        FetchAll ->
            Cmd.none

        AddEntry text ->
            Cmd.none

        RemoveEntry id ->
            Cmd.none

        ToggleComplete id ->
            Cmd.none


-- HELPERS

toggleComplete : Int -> List Entry -> List Entry
toggleComplete id list =
    List.map (updateEntry id) list


updateEntry : Int -> (Entry -> Entry)
updateEntry id =
    \entry ->
        if entry.id == id then
            { entry | complete = not entry.complete }
        else
            entry
