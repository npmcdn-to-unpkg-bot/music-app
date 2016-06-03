module Spotify.Image exposing (..)

import Maybe exposing (Maybe)
import Json.Decode as Json exposing ((:=))


type alias Image =
  { url : String
  , height : Maybe Int
  , width : Maybe Int
  }

none : Image
none =
  Image "" Nothing Nothing

decode : Json.Decoder Image
decode =
  Json.object3 Image
    ("url" := Json.string)
    (Json.maybe ("height" := Json.int))
    (Json.maybe ("width" := Json.int))
