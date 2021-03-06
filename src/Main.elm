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
import Debug


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { searchResult : SearchResult
  , currentTrack : Track
  , searchInput : String
  , playing : Bool
  }

type alias SearchResult =
  { tracks : List Track
  , albums : List Album.Simple
  , artists : List Artist.Simple
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
  | ApiMsg Api.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Search name ->
      ({ model | searchInput = name }, Cmd.map ApiResponse (Api.search name))

    Select track ->
      ({ model | currentTrack = track }, Cmd.none)

    Play ->
      ({ model | playing = True }, Cmd.none)

    Stop ->
      ({ model | playing = False }, Cmd.none)

    ApiResponse result ->
      ({ model | searchResult = Api.get result }, Cmd.none)
      
    _ ->
      Debug.crash "Went through"


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ viewSearchBar
    , viewTrackList model.trackList
    ]

viewTrackList : List Track -> Html Msg
viewTrackList albums =
  ul [Class.albumList]
    (List.map viewTrack albums)

viewTrack : Track -> Html Msg
viewTrack album =
  li [Class.albumListItem]
    [text album.name]

viewSearchBar : Html Msg
viewSearchBar =
  input [Class.searchBar, placeholder "Search music", onInput Search] []


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
