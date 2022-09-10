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
    
    Msg.Swap playerA playerB ->
      model

    Msg.PlayerA (player) ->
      model
    
    Msg.PlayerB (player) ->
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
    , playerA : PlayerOrPlaceholder
    , playerB : PlayerOrPlaceholder
    }

 
init : Model
init =
  let
      attackers = [ Player { name = "Jesus", position = Player.ATT, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 60, scout_value = 40 }
                  , Player { name = "Martinelli", position = Player.ATT, chemistry = Player.Right, ability = 3, potential = 6, market_value = 40, scout_value = 20 }
                  , Player { name = "Saka", position = Player.ATT, chemistry = Player.Left, ability = 4, potential = 6, market_value = 25, scout_value = 12 }
                  ]
      midfielders = [ Player { name = "Odegaard", position = Player.MID, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                    , Player { name = "Xhaka", position = Player.MID, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                    , Player { name = "Thomas", position = Player.MID, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                    ]
      defenders = [ Player { name = "Tierney", position = Player.DEF, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  , Player { name = "Saliba", position = Player.DEF, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  , Player { name = "White", position = Player.DEF, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  , Player { name = "Tomiyasu", position = Player.DEF, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  ]
      reserves = [ Player { name = "Nketiah", position = Player.ATT, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 } 
                  , Player { name = "Turner", position = Player.GK, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  , Player { name = "Cedric", position = Player.DEF, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  , Player { name = "Erik", position = Player.DEF, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  , Player { name = "Caroline", position = Player.GK, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                  ]
      club =   { balance = 100
                , stadium_level = Club.I
                , scouting_level = Club.I
                , training_level = Club.I
                , club_level = Club.NewlyPromoted
                , club_position = Club.Fifth
                , attackers = attackers
                , midfielders = midfielders
                , defenders = defenders
                , goalkeeper = Player { name = "Ramsdale", position = Player.GK, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 10, scout_value = 5 }
                , reserves = reserves
                }
  in
  { club = club
  , playerA = PlayerPlaceholder ""
  , playerB = PlayerPlaceholder "" }



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

