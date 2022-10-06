module PlayerDisplay exposing (..)
import Player exposing (..)
import Gamestyle
import Msg exposing (Msg)
-- Display Packages
import Css exposing (rgb, hex)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Events exposing (onMouseDown)
import String exposing (left)

-- Display for PlayerOrPlaceholder
playerStyle: PlayerOrPlaceholder -> Css.Style
playerStyle a =
  let
      color = case a of 
        PlayerPlaceholder _ ->
          (hex "#e0e0e0")
        Player player ->
          case player.position of
            GK -> rgb 252 103 3
            DEF -> hex "#e01e26"
            MID -> hex "#fcc800"
            ATT -> hex "#00913c"
  in
  Gamestyle.playerPlaceholderStyle color



playerToHtml: PlayerOrPlaceholder -> StyledHtml.Html Msg
playerToHtml a =
  let
      textStyle = [ Css.color (Css.rgb 255 255 255)
                  , Gamestyle.centerText
                  , Css.textAlign Css.textTop
                  ]
  in
  StyledHtml.node "player" 
    [ playerId a |> class
    , css [ playerStyle a, Css.display Css.block ] 
    ]
    [ StyledHtml.h4 [ css textStyle ] [ a |> name |> text ] 
    , displayAbility a
    ]
  -- div 
  --   [ class <| playerId a
  --   , css [ Gamestyle.paddingStyle, Css.float Css.left ]
  --   ]
  --   [ div 
  --     [ css [ playerStyle a ] 
  --     , class "player-card"
  --     -- , onMouseDown (Msg.Swap a)
  --     ]
  --     [ StyledHtml.h4 [ css textStyle ] [ a |> name |> text ] 
  --     , displayAbility a
  --     ]
  --   ]
  -- case a of
  --     PlayerPlaceholder _ -> div [] []
  --     Player player ->
  --       div 
  --         [ class player.name
  --         , css [ Gamestyle.paddingStyle, Css.float Css.left ] 
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

