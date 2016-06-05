module Spotify.Api exposing (..)

import Http
import Json.Decode as Json
import Task
import Spotify.Artist as Artist
import Spotify.Album as Album
import Spotify.Track as Track exposing (Track)


type SearchResponse
  = TrackResponse (List Track)
  | AlbumResponse (List Album.Simple)
  | ArtistResponse (List Artist.Simple)

type Msg
  = Success SearchResponse
  | Error Http.Error

baseUrl : String
baseUrl = "https://api.spotify.com/v1"

toResult : SearchResponse -> List Track
toResult response =
  case response of
    TrackResponse tracks ->
      tracks
    _ -> []
      

search : String -> Cmd Msg
search string =
  Cmd.batch
    [ searchTracks string
    , searchAlbums string
    , searchArtists string
    ]

searchTracks : String -> Cmd Msg
searchTracks string =
  let
    url =
      baseUrl ++ "/search?type=track&q=" ++ Http.uriEncode string
    
    decodeTracks =
      Json.at ["tracks", "items"] (Json.list Track.decode)
  in
    Task.perform Error Success (Task.map TrackResponse (Http.get decodeTracks url))
 
searchAlbums : String -> Cmd Msg
searchAlbums string =
  let
    url =
      baseUrl ++ "/search?type=album&q=" ++ Http.uriEncode string
      
    decodeAlbums =
      Json.at ["albums", "items"] (Json.list Album.decodeSimple)
  in
    Task.perform Error Success (Task.map AlbumResponse (Http.get decodeAlbums url))

searchArtists : String -> Cmd Msg
searchArtists string =
  let
    url =
      baseUrl ++ "/search?type=artist&q=" ++ Http.uriEncode string
    
    decodeArtists =
      Json.at ["artists", "items"] (Json.list Artist.decodeSimple)
  in
    Task.perform Error Success (Task.map ArtistResponse (Http.get decodeArtists url))