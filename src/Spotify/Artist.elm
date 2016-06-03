module Spotify.Artist exposing (..)

import Json.Decode as Json exposing ((:=))
import Http
import Task
import Maybe exposing (Maybe(..))
import Spotify.Image as Image exposing (Image)
import Spotify.Api exposing (baseUrl)


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

type Msg
  = Success (List Simple)
  | Error Http.Error

noneSimple : Simple
noneSimple =
  Simple "" ""

noneFull : Full
noneFull =
  Full "" "" [] 0

get : Msg -> Maybe (List Simple)
get msg =
  case msg of
    Success artists -> Just artists
    Error err -> Nothing

search : String -> Cmd Msg
search string =
  let
    url = baseUrl ++ "/search?type=artist&q=" ++ Http.uriEncode string
  in
    Task.perform Error Success (Http.get (Json.list decodeSimple) url)

decodeSimple : Json.Decoder Simple
decodeSimple =
  Json.object2 Simple
    ("name" := Json.string)
    ("id" := Json.string)
