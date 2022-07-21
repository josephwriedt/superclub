module Model exposing (..)
import Club exposing (Club)
import Player exposing (Player)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import String
import GameStyle
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css
import Html exposing (section)
import List exposing (map)
import Msg exposing (Msg)

-- type alias Model = 
--     { clubs : List Club
--     -- , key_staff : List Staff
--     , players : List Player
--     , inactive_players : List Player
--     }




-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    Msg.Increment ->
      model 

    Msg.Decrement ->
      model



-- VIEW
view : Model -> Html.Html Msg
view model =
    -- model |> squadView |>  toUnstyled
    model |> Club.clubFolderHtml |> toUnstyled

    

squadView : Model -> StyledHtml.Html Msg
squadView club = 
  let
      squad = Club.squad club
  in
  

    StyledHtml.div
    [ css [  ] ]
    <| [ squadToHtml squad ]



-- MODEL
type alias Model = 
    Club
 
init : Club
init =
  let
      attackers = [ Player "Gabriel Jesus" Player.ATT Player.None 5 5 10 5 
                  , Player "Gabriel Martinelli" Player.ATT Player.Left 3 6 25 12
                  , Player "Bukayo Saka" Player.ATT Player.Left 3 6 25 12 
                  ]
      midfielders = [ Player "Martin Odeegard" Player.MID Player.None 5 5 10 5 
                    , Player "Granit Xhaka" Player.MID Player.Left 3 6 25 12
                    , Player "Thomas Partey" Player.MID Player.Left 3 6 25 12
                    ]
      defenders = [ Player "Kieran Tierney" Player.DEF Player.None 5 5 10 5 
                  , Player "William Saliba" Player.DEF Player.Left 3 6 25 12
                  , Player "Ben White" Player.DEF Player.Left 3 6 25 12
                  , Player "Takehiro Tomayisu" Player.DEF Player.Left 3 6 25 12
                  ]
      reserves = [ Player "Eddie Nketiah" Player.ATT Player.None 5 5 10 5 
                  , Player "Matt Turner" Player.GK Player.Left 3 6 25 12
                  , Player "Cedric Soares" Player.DEF Player.Left 3 6 25 12
                  ]
  in
  { balance = 100
  , stadium_level = Club.I
  , scouting_level = Club.I
  , training_level = Club.I
  , club_level = Club.NewlyPromoted
  , club_position = Club.Fifth
  , attackers = attackers
  , midfielders = midfielders
  , defenders = defenders
  , goalkeeper = Player "Petr Cech" Player.GK Player.None 1 1 0 0
  , reserves = reserves
  }

    

-- cols: Int -> Css.LengthOrNumberOrAutoOrNoneOrContent
-- flex num = 
--   Css.LengthOrNumberOrAutoOrNoneOrContent

squadToHtml: List Player -> StyledHtml.Html Msg
squadToHtml players = 
  let
    attributes = [ css 
                    [ Css.display Css.inlineFlex
                    , Css.flexFlow1 Css.wrap
                    ]
                  ]

    squadHtml = map Player.playerToHtml players
  in
  -- Pass attributes to players' html
  StyledHtml.node "Squad" attributes squadHtml

    

