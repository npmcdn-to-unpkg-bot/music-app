module Spotify.Track exposing (..)

import Json.Decode as Json exposing ((:=))
import Spotify.Artist as Artist


type alias Track =
  { name : String
  , id: String
  , artists : List Artist.Simple
  , duration : Int
  }

none : Track
none =
  Track "" "" [] 0

decode : Json.Decoder Track
decode =
  Json.object4 Track
    ("name" := Json.string)
    ("id" := Json.string)
    ("artists" := Json.list Artist.decodeSimple)
    ("duration_ms" := Json.int)
