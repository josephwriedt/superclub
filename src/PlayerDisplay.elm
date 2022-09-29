module PlayerDisplay exposing (..)
import Player exposing (..)
import GameStyle
import Msg exposing (Msg)
-- Display Packages
import Css
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Events exposing (onMouseDown)

-- Display for PlayerOrPlaceholder
playerStyle: PlayerOrPlaceholder -> Css.Style
playerStyle a =
  case a of
    PlayerPlaceholder _ -> 
      GameStyle.playerPlaceholderStyle
    Player player ->
      case player.position of
        GK -> GameStyle.goalkeeperStyle
        DEF -> GameStyle.defenderStyle
        MID -> GameStyle.midfielderStyle
        ATT -> GameStyle.attackerStyle



playerToHtml: PlayerOrPlaceholder -> StyledHtml.Html Msg
playerToHtml a =
  let
      textStyle = [ Css.color (Css.rgb 255 255 255)
                  , GameStyle.centerText
                  , Css.textAlign Css.textTop
                  ]
  in
  div 
    [ class <| playerId a
    , css [ GameStyle.paddingStyle, Css.float Css.left ]
    ]
    [ div 
      [ css [ playerStyle a ] 
      , class "player-card"
      -- , onMouseDown (Msg.Swap a)
      ]
      [ StyledHtml.h4 [ css textStyle ] [ a |> name |> text ] 
      , displayAbility a
      ]
    ]
  -- case a of
  --     PlayerPlaceholder _ -> div [] []
  --     Player player ->
  --       div 
  --         [ class player.name
  --         , css [ GameStyle.paddingStyle, Css.float Css.left ] 
  --         ] 
  --         [
  --           div 
  --           [ css  [ playerStyle a ]
  --           , class "player-card"
  --         --   , onMouseDown (Msg.Select { PlayerOrPlaceholder = PlayerOrPlaceholder })
  --           ]
  --           [ StyledHtml.h4 [ css textStyle ] [ text player.name ]
  --           , displayAbility a
  --           ]
  --         ]

