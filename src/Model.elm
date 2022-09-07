module Model exposing (..)
import Club exposing (Club)
import Player exposing (Player)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css
import List exposing (map)
import Msg exposing (Msg)


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
      attackers = [ Player "Jesus" Player.ATT Player.None 5 5 10 5 
                  , Player "Martinelli" Player.ATT Player.Left 3 6 25 12
                  , Player "Saka" Player.ATT Player.Left 4 6 25 12 
                  ]
      midfielders = [ Player "Odeegard" Player.MID Player.None 4 5 10 5 
                    , Player "Xhaka" Player.MID Player.Left 4 4 25 12
                    , Player "Thomas" Player.MID Player.Left 5 5 25 12
                    ]
      defenders = [ Player "Tierney" Player.DEF Player.None 4 5 10 5 
                  , Player "Saliba" Player.DEF Player.Left 2 6 25 12
                  , Player "White" Player.DEF Player.Left 3 6 25 12
                  , Player "Tomayisu" Player.DEF Player.Left 3 5 25 12
                  ]
      reserves = [ Player "Nketiah" Player.ATT Player.None 2 4 10 5 
                  , Player "Turner" Player.GK Player.Left 2 3 25 12
                  , Player "Cedric" Player.DEF Player.Left 2 2 25 12
                  , Player "Erik" Player.DEF Player.Both 6 6 0 0
                  , Player "Caroline" Player.GK Player.None 6 6 120 80
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
  , goalkeeper = Player "Cech" Player.GK Player.None 1 1 0 0
  , reserves = reserves
  }


squadToHtml: List Player -> StyledHtml.Html Msg
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

