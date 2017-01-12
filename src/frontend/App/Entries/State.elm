module App.Entries.State exposing (..)

import App.Types as App
import App.Entries.Types exposing (..)
import App.Control.Types exposing (Filter(..))
import App.Entries.Rest as Rest

-- INIT

initialModel : Model
initialModel =
    { list = []
    , filter = All
    , currentId = 0
    }


initialCmd : Cmd App.Msg 
initialCmd =
    Rest.fetchAll



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
        FetchAllResponse (Ok list) ->
            { model | list = list }

        FetchAllResponse (Err _) ->
            model

        AddEntryResponse (Ok entry) ->
            model
            --{ model 
            --    | list = List.append model.list [ Entry model.currentId text False ]
            --    , currentId = model.currentId + 1
            --}

        AddEntryResponse (Err _) ->
            model

        RemoveEntryResponse (Ok id) ->
            model
            --{ model | list = List.filter (\entry -> not <| entry.id == id) model.list }

        RemoveEntryResponse (Err _) ->
            model

        ToggleCompleteResponse (Ok id) ->
            model
            --{ model | list = toggleComplete id model.list }

        ToggleCompleteResponse (Err _) ->
            model


updateCmd : CmdMsg -> Model -> Cmd App.Msg
updateCmd cmdMsg model =
    case cmdMsg of
        FetchAllRequest ->
            Rest.fetchAll

        AddEntryRequest text ->
            Rest.addEntry text

        RemoveEntryRequest id ->
            Rest.removeEntry id

        ToggleCompleteRequest id ->
            Rest.toggleComplete id


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
