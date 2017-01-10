module App.Control.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Utility.OnLinkClick exposing (onLinkClick)

import App.Types as App
import App.Routes as Routes
import App.Control.Types as Control exposing (Filter(..))
import App.Entries.Types as Entries exposing (..)


view : Control.Model -> Html App.Msg
view model =
    div [ class "control" ]
        [ viewFilters
            [ ( All, model.filter )
            , ( Active, model.filter )
            , ( Complete, model.filter )
            ]
        ]


viewFilters : List ( Filter, Filter ) -> Html App.Msg
viewFilters options =
    div [] (List.map viewFilter options)


viewFilter : ( Filter, Filter ) -> Html App.Msg
viewFilter ( filter, current ) = 
    let
        filterStyle =
            if filter == current then
                " current"
            else
                " "

        route =
            case filter of
                All -> Routes.All
                Active -> Routes.Active
                Complete -> Routes.Complete
    in
        a
            [ href (Routes.routeToPath route)
            , class ("filter" ++ filterStyle)
            , onLinkClick (App.NavigateTo route)
            ]
            [ text (toString filter)
            ]

