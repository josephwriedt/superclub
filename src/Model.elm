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

-- type alias Model = 
--     { clubs : List Club
--     -- , key_staff : List Staff
--     , players : List Player
--     , inactive_players : List Player
--     }

type Msg
  = Increment
  | Decrement


-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model 

    Decrement ->
      model



-- VIEW
view : Model -> Html.Html Msg
view model =
    model |> squadView |>  toUnstyled

    

squadView : Model -> StyledHtml.Html Msg
squadView squad = 

    StyledHtml.div
    [ css [  ] ]
    <| [ squadToHtml squad ]



-- MODEL
type alias Model = 
    -- Player
    List Player
 
init : Model
init =
    -- Player "John Terry" Player.DEF Player.None 5 5 10 5 
  [ Player "John Terry" Player.DEF Player.None 5 5 10 5 
  , Player "Mason Mount" Player.MID Player.Left 3 6 25 12
  , Player "Bukayo Saka" Player.MID Player.Left 3 6 25 12
  , Player "Mason Mount" Player.MID Player.Left 3 6 25 12
  , Player "Mason Mount" Player.MID Player.Left 3 6 25 12
  , Player "Mason Mount" Player.MID Player.Left 3 6 25 12
  , Player "Mason Mount" Player.MID Player.Left 3 6 25 12
  , Player "Chloey Da Big Forehead" Player.GK Player.None 0 0 0 0
  ]

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

    squadHtml = map playerToHtml players
  in
  -- Pass attributes to players' html
  StyledHtml.node "Squad" attributes squadHtml

    
playerToHtml: Player -> StyledHtml.Html Msg
playerToHtml player =
    div 
    [ class player.name
    , css [ GameStyle.paddingStyle ] 
    ] 
    [
        div 
        [ css  [ GameStyle.cardStyle ]
        , class "player-card"
        ]
        [ h2 [ css [ GameStyle.centerText, Css.textAlign Css.textTop ] ] [ text player.name ]
        , h4 [] [ player.position |> Player.positionToString |> text ]
        , h4 [] [ player.chemistry |> Player.chemistryToString |> text ]
        , h4 [] [ text (String.fromInt player.ability ++ " out of " ++ String.fromInt player.potential) ]
        
        ]
    ]
     
