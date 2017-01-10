module App.Routes exposing (..)

import Navigation
import UrlParser exposing (Parser, (</>), oneOf, map, s, string)

type Route
    = All
    | Active
    | Complete


pathParser : Navigation.Location -> Maybe Route
pathParser location =
    UrlParser.parsePath pageParser location


pageParser : Parser (Route -> a) a
pageParser =
    oneOf
        [ map All (s "")
        , map Active (s "active")
        , map Complete (s "complete")
        ]