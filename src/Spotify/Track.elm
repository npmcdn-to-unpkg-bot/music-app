module Spotify.Track exposing (..)

import Json.Decode as Json exposing ((:=))
import Http
import Task
import Maybe exposing (Maybe(..))
import Spotify.Artist as Artist
import Spotify.Api exposing (baseUrl)

type alias Track =
  { id: String
  , name : String
  , artists : List Artist.Simple
  , duration : Int
  }

type Msg
  = Success (List Track)
  | Error Http.Error

none : Track
none =
  Track "" "" [] 0

get : Msg -> Maybe (List Track)
get msg =
  case msg of
    Success tracks -> Just tracks
    Error err -> Nothing

search : String -> Cmd Msg
search string =
  let
    url = baseUrl ++ "/search?type=track&q=" ++ Http.uriEncode string
  in
    Task.perform Error Success (Http.get (Json.list decode) url)

decode : Json.Decoder Track
decode =
  Json.object4 Track
    ("name" := Json.string)
    ("id" := Json.string)
    ("artists" := Json.list Artist.decodeSimple)
    ("duration" := Json.int)
