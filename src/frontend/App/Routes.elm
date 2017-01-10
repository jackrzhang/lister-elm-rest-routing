module App.Routes exposing (..)

import Navigation
import UrlParser exposing (Parser, (</>), oneOf, map, s, string)

type Route
    = All
    | Active
    | Complete


routeToPath : Route -> String
routeToPath route =
    case route of 
        All -> 
            "/"

        Active ->
            "/active"

        Complete ->
            "/complete"


pathParser : Navigation.Location -> Maybe Route
pathParser location =
    UrlParser.parsePath routeParser location


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map All (s "")
        , map Active (s "active")
        , map Complete (s "complete")
        ]
