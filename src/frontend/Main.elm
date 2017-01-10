module Main exposing (main)

import Navigation exposing (Location)

import App.Types exposing (..)
import App.State
import App.View


main : Program Never Model Msg
main =
    Navigation.program
        UrlChange
        { init = App.State.init
        , update = App.State.update
        , view = App.View.view
        , subscriptions = \_ -> Sub.none
        }
