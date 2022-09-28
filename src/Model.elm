module Model exposing (..)
import Club exposing (Club)
import Player exposing (PlayerOrPlaceholder, playerPlaceHolderName)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css
import List exposing (map)
import Msg exposing (Msg)
import Player exposing (PlayerOrPlaceholder(..))
import Array exposing (Array)
import Init

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    Msg.Increment ->
      model 

    Msg.Decrement ->
      model

    Msg.Select (player) ->
      model
    
    Msg.Swap player ->
      { model | swapPlayers = player :: model.swapPlayers } |> swapPlayersWithinClub

    Msg.Draft (player) ->
      model



-- VIEW
view : Model -> Html.Html Msg
view model =
    -- model |> squadView |>  toUnstyled
    model.club |> Club.clubFolderHtml |> toUnstyled

    

squadView : Model -> StyledHtml.Html msg
squadView model = 
  let
      club = model.club
      squad = Club.squad club
  in
  

    StyledHtml.div
    [ css [  ] ]
    <| [ squadToHtml squad ]



-- MODEL
type alias Model = 
    { club : Club 
    , swapPlayers : List PlayerOrPlaceholder
    }


 
init : Model
init =
  let
    reserves = Array.fromList Init.arsenalReserves
    starters = Array.fromList Init.arsenalStarters
      -- Array.initialize 20 (\n -> playerPlaceHolderName "starter" n)
    club = { balance = 100
           , stadium_level = Club.I
           , scouting_level = Club.I
           , training_level = Club.I
           , club_level = Club.NewlyPromoted
           , club_position = Club.Fifth
           , reserves = reserves
           , starters = starters
           }
  in
  { club = club
  , swapPlayers = [] }


swapPlayersWithinClub: Model -> Model
swapPlayersWithinClub model =
  case List.length model.swapPlayers of
    2 -> 
      -- here we swap players
      model
    _ -> model



squadToHtml: List PlayerOrPlaceholder -> StyledHtml.Html msg
squadToHtml players = 
  let
    attributes = [ css 
                    [ Css.display Css.inlineFlex
                    , Css.flexFlow1 Css.wrap
                    ]
                  , class "squad"
                  ]

    squadHtml = map Player.playerToHtml players
  in
  StyledHtml.div attributes squadHtml

