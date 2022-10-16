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

playerToHtml : PlayerOrPlaceholder -> List Css.Style -> List (Attribute Msg) -> StyledHtml.Html Msg
playerToHtml player styles attributeList =
  let
      textStyle = [ Css.color (Css.rgb 255 255 255), Gamestyle.centerText ]
      attributes = List.append attributeList   
        [ playerId player |> class
        , css <| List.append styles [ playerStyle player, Css.display Css.block ]
        , Html.Styled.Attributes.draggable "true"
        , Msg.onDragStart <| Msg.Drag player
        , Msg.onDragEnd Msg.DragEnd
        , Msg.onDrop <| Msg.Drop player
        , Msg.onDragOver Msg.DragOver
        ]
  in
  StyledHtml.node "player" attributes
    [ StyledHtml.h4 [ css textStyle ] [ player |> name |> text ] 
    , displayAbility player
    ]


playerToHtmlDefault: PlayerOrPlaceholder -> StyledHtml.Html Msg
playerToHtmlDefault player =
  playerToHtml player [] []
  