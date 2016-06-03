module Spotify.SearchResult exposing (..)

import Spotify.Track exposing (Track)
import Spotify.Album as Album
import Spotify.Artist as Artist

type alias SearchResult =
  { artists : List Artist.Simple
  , tracks : List Track
  , albums : List Album.Simple
  }

none : SearchResult
none =
  SearchResult [] [] []
