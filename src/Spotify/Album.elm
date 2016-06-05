module Spotify.Album exposing (..)

import Date exposing (Date)
import Json.Decode as Json exposing ((:=))
import Spotify.Track as Track exposing (Track)
import Spotify.Image as Image exposing (Image)
import Spotify.Artist as Artist


type alias Simple =
  { name : String
  , id : String
  , images : List Image
  }

type alias Full =
  { name : String
  , id : String
  , artists : List Artist.Simple
  , images : List Image
  , tracks : List Track
  , genres : List String
  , releaseDate : Date
  , popularity : Int
  }

noneFull : Full
noneFull =
  Full "" "" [] [] [] [] (Date.fromTime 0) 0

noneSimple : Simple
noneSimple =
  Simple "" "" []

decodeSimple : Json.Decoder Simple
decodeSimple =
  Json.object3 Simple
    ("name" := Json.string)
    ("id" := Json.string)
    ("images" := Json.list Image.decode)
