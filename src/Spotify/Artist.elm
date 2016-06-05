module Spotify.Artist exposing (..)

import Json.Decode as Json exposing ((:=))
import Spotify.Image as Image exposing (Image)


type alias Full =
  { name : String
  , id : String
  , images : List Image
  , popularity : Int
  }

type alias Simple =
  { name : String
  , id : String
  }

noneSimple : Simple
noneSimple =
  Simple "" ""

noneFull : Full
noneFull =
  Full "" "" [] 0

decodeSimple : Json.Decoder Simple
decodeSimple =
  Json.object2 Simple
    ("name" := Json.string)
    ("id" := Json.string)
