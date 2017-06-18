module Utility.OnLinkClick exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


onLinkClick : msg -> Attribute msg
onLinkClick msg =
    let options =
        { stopPropagation = True
        , preventDefault = True
        } 

    in
        onWithOptions "click" options (Json.succeed msg)