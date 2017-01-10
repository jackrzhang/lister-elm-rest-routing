module App.Routes exposing (..)

import Navigation
import UrlParser exposing (Parser, (</>), oneOf, map, s, string)

type Page
    = All
    | Active
    | Complete


pathParser : Navigation.Location -> Maybe Page
pathParser location =
    UrlParser.parsePath pageParser location


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ map All (s "")
        , map Active (s "active")
        , map Complete (s "complete")
        ]