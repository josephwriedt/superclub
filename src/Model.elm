module Model exposing (..)
import Club exposing (Club)
import Player exposing (PlayerOrPlaceholder)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css
import List exposing (map)
import Msg exposing (Msg)
import PlayerDisplay
import Player exposing (PlayerOrPlaceholder(..))
import Array exposing (Array)

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

playerPlaceHolderName: String -> Int -> Player.PlayerOrPlaceholder
playerPlaceHolderName positionName id =
  String.join "-" [ positionName, String.fromInt id ] |> Player.PlayerPlaceholder 
 
init : Model
init =
  let
      attackers = 
                  [ Player { name = "Jesus", position = Player.ATT, chemistry = Player.NoChemistry, ability = 4, potential = 5, market_value = 60, scout_value = 40 }
                  , Player { name = "Martinelli", position = Player.ATT, chemistry = Player.Right, ability = 3, potential = 5, market_value = 40, scout_value = 20 }
                  , Player { name = "Saka", position = Player.ATT, chemistry = Player.Left, ability = 3, potential = 6, market_value = 25, scout_value = 12 }
                  , playerPlaceHolderName "starter" 1
                  , playerPlaceHolderName "starter" 2
                  , playerPlaceHolderName "starter" 3
                  ]
      midfielders = [ Player { name = "Odegaard", position = Player.MID, chemistry = Player.NoChemistry, ability = 3, potential = 6, market_value = 30, scout_value = 5 }
                    , Player { name = "Xhaka", position = Player.MID, chemistry = Player.Right, ability = 3, potential = 3, market_value = 20, scout_value = 10 }
                    , Player { name = "Thomas", position = Player.MID, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 35, scout_value = 24 }
                    , PlayerPlaceholder "3"
                    , PlayerPlaceholder "4"
                    ]
      defenders = [ Player { name = "Tierney", position = Player.DEF, chemistry = Player.Right, ability = 3, potential = 4, market_value = 30, scout_value = 15 }
                  , Player { name = "Saliba", position = Player.DEF, chemistry = Player.NoChemistry, ability = 3, potential = 6, market_value = 45, scout_value = 27 }
                  , Player { name = "White", position = Player.DEF, chemistry = Player.Right, ability = 3, potential = 4, market_value = 10, scout_value = 5 }
                  , Player { name = "Tomiyasu", position = Player.DEF, chemistry = Player.NoChemistry, ability = 3, potential = 3, market_value = 20, scout_value = 10 }
                  , PlayerPlaceholder "5"
                  ]
      reserves = Array.fromList [ Player { name = "Nketiah", position = Player.ATT, chemistry = Player.Left, ability = 2, potential = 5, market_value = 25, scout_value = 15 } 
                  , Player { name = "Turner", position = Player.GK, chemistry = Player.NoChemistry, ability = 2, potential = 2, market_value = 15, scout_value = 10 }
                  , Player { name = "Cedric", position = Player.DEF, chemistry = Player.NoChemistry, ability = 2, potential = 3, market_value = 10, scout_value = 5 }
                  , Player { name = "Erik", position = Player.DEF, chemistry = Player.Left, ability = 6, potential = 6, market_value = 100, scout_value = 5 }
                  , Player { name = "Caroline", position = Player.GK, chemistry = Player.NoChemistry, ability = 6, potential = 6, market_value = 10, scout_value = 5 }
                  , PlayerPlaceholder "6"
                  , PlayerPlaceholder "7"
                  , PlayerPlaceholder "8"
                  ]
      starters = Array.initialize 20 (\n -> playerPlaceHolderName "starter" n)
      club =   { balance = 100
                , stadium_level = Club.I
                , scouting_level = Club.I
                , training_level = Club.I
                , club_level = Club.NewlyPromoted
                , club_position = Club.Fifth
                -- , attackers = attackers
                -- , midfielders = midfielders
                -- , defenders = defenders
                -- , goalkeeper = Player { name = "Ramsdale", position = Player.GK, chemistry = Player.NoChemistry, ability = 3, potential = 5, market_value = 30, scout_value = 15 }
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

    squadHtml = map PlayerDisplay.playerToHtml players
  in
  StyledHtml.div attributes squadHtml

