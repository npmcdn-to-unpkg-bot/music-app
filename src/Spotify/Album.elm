module Spotify.Album exposing (..)

import Date exposing (Date)
import Json.Decode as Json exposing ((:=))
import Http
import Task
import Maybe exposing (Maybe(..))
import Spotify.Track as Track exposing (Track)
import Spotify.Image as Image exposing (Image)
import Spotify.Artist as Artist
import Spotify.Api exposing (baseUrl)


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

type Msg
  = Success (List Simple)
  | Error Http.Error

noneFull : Full
noneFull =
  Full "" "" [] [] [] [] (Date.fromTime 0) 0

noneSimple : Simple
noneSimple =
  Simple "" "" []

get : Msg -> Maybe (List Simple)
get msg =
  case msg of
    Success albums -> Just albums
    Error err -> Nothing

search : String -> Cmd Msg
search string =
  let
    url = baseUrl ++ "/search?type=album&q=" ++ Http.uriEncode string
  in
    Task.perform Error Success (Http.get (Json.list decodeSimple) url)

decodeSimple : Json.Decoder Simple
decodeSimple =
  Json.object3 Simple
    ("name" := Json.string)
    ("id" := Json.string)
    ("images" := Json.list Image.decode)
