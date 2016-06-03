import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Spotify.Track as Track exposing (Track)
import Spotify.SearchResult as SearchResult exposing (SearchResult)
import Spotify.Album as Album
import Spotify.Artist as Artist
import Class exposing (..)


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { albumList : List Album.Simple
  , trackList : List Track
  , searchResult : SearchResult
  , currentTrack : Track
  , searchInput : String
  , playing : Bool
  }

init : (Model, Cmd Msg)
init =
  (Model [] [] SearchResult.none Track.none "" False, Cmd.none)


-- UPDATE

type Msg
  = Search String
  | Select Track
  | Play
  | Stop
  | TrackMsg Track.Msg
  | AlbumMsg Album.Msg
  | ArtistMsg Artist.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Search name ->
      let cmd =
        if String.length name > 1 then
          Track.search name
        else
          Cmd.none
      in ({ model | searchInput = name }, cmd)

    Select track ->
      ({ model | currentTrack = track }, Cmd.none)

    Play ->
      ({ model | playing = True }, Cmd.none)

    Stop ->
      ({ model | playing = False }, Cmd.none)

    TrackMsg track ->
      case Track.get track of
        Just trackList ->
          ({ model | trackList = trackList }, Cmd.none)
        Nothing ->
          (model, Cmd.none)

    _ ->
      Debug.crash "Went through"


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ viewSearchBar
    , viewAlbumList model.albumList
    ]

viewAlbumList : List Album.Simple -> Html Msg
viewAlbumList albums =
  ul [Class.albumList]
    (List.map viewAlbum albums)

viewAlbum : Album.Simple -> Html Msg
viewAlbum album =
  li [Class.albumListItem]
    [text album.name]

viewSearchBar : Html Msg
viewSearchBar =
  input [Class.searchBar, placeholder "Search music", onInput Search] []


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
