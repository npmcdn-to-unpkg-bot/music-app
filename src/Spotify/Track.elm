module Spotify.Track exposing (..)

import Json.Decode as Json exposing ((:=))
import Http
import Task
import Spotify.Artist as Artist
import Spotify.Api exposing (baseUrl)
import Debug

type alias Track =
  { name : String
  , id: String
  , artists : List Artist.Simple
  , duration : Int
  }

type Msg
  = Success (List Track)
  | Error Http.Error

none : Track
none =
  Track "" "" [] 0

get : Msg -> List Track
get msg =
  case msg of
    Success tracks ->
      let log = Debug.log "Success" tracks 
      in tracks
    Error err ->
      let
        log = Debug.log "Error" err
      in []

search : String -> Cmd Msg
search string =
  let
    url = baseUrl ++ "/search?type=track&q=" ++ Http.uriEncode string
    decodeTracks = Json.at ["tracks", "items"] (Json.list decode)
  in
    Task.perform Error Success (Http.get decodeTracks url)

decode : Json.Decoder Track
decode =
  Json.object4 Track
    ("name" := Json.string)
    ("id" := Json.string)
    ("artists" := Json.list Artist.decodeSimple)
    ("duration_ms" := Json.int)
