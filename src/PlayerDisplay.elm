module PlayerDisplay exposing (..)
import Player exposing (..)
import Msg exposing (Msg)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Css exposing (position)
import Html.Styled.Attributes exposing (attribute, css, class)
import GameStyle
import Html.Styled.Events exposing (onClick)
import Html.Styled.Events exposing (onMouseDown)


playerStyle: Player -> Css.Style
playerStyle player =
  case player.position of
    GK -> GameStyle.goalkeeperStyle
    DEF -> GameStyle.defenderStyle
    MID -> GameStyle.midfielderStyle
    ATT -> GameStyle.attackerStyle


playerToHtml: Player -> StyledHtml.Html msg
playerToHtml player =
  let
      textStyle = [ Css.color (Css.rgb 255 255 255)
                  , GameStyle.centerText
                  , Css.textAlign Css.textTop
                  ]
  in
  div 
    [ class player.name
    , css [ GameStyle.paddingStyle, Css.float Css.left ] 
    ] 
    [
      div 
      [ css  [ playerStyle player ]
      , class "player-card"
    --   , onMouseDown (Msg.Select { player = player })
      ]
      [ StyledHtml.h4 [ css textStyle ] [ text player.name ]
      , displayAbility player
      ]
    ]


-- Star Generation
type Star = Placeholder | Current | Potential 

generateStar: Star -> StyledHtml.Html msg
generateStar star =
  case star of
    Placeholder ->
      StyledHtml.span [] []

    Current ->
      GameStyle.filledStar

    Potential ->
      GameStyle.unfilledStar

generateStarFromMatrix: List (List Star) -> List(StyledHtml.Html msg)
generateStarFromMatrix matrix =
  let
      generateStarsRow list = 
        div [ class "star-row", css [ GameStyle.centerText ] ] 
          <| List.map generateStar list   
  in
  matrix |> List.map generateStarsRow


displayAbility: Player -> StyledHtml.Html msg
displayAbility player = 
  let
      stars = 
        case (player.ability, player.potential) of
          -- Current Ability of 1
          (1, 1) ->
            generateStarFromMatrix [ [ Placeholder, Current, Placeholder ], [ Placeholder, Placeholder, Placeholder ] ]
          (1, 2) -> 
            generateStarFromMatrix [ [ Current, Placeholder, Potential ], [ Placeholder, Placeholder, Placeholder ] ]
          (1, 3) ->
            generateStarFromMatrix [ [ Current, Potential, Potential ], [ Placeholder, Placeholder, Placeholder ] ]
          (1, 4) ->
            generateStarFromMatrix [ [ Current, Placeholder, Potential ], [ Potential, Placeholder, Potential ] ]
          (1, 5) ->
            generateStarFromMatrix [ [ Current, Potential, Potential ], [ Potential, Placeholder, Potential ] ]
          (1, 6) ->
            generateStarFromMatrix [ [ Current, Potential, Potential ], [ Potential, Potential, Potential ] ]
          
          -- Current Ability of 2
          (2, 2) ->
            generateStarFromMatrix [ [ Current, Placeholder, Current ], [ Placeholder, Placeholder, Placeholder ] ]
          (2, 3) ->
            generateStarFromMatrix [ [ Current, Current, Potential ], [ Placeholder, Placeholder, Placeholder ] ]
          (2, 4) ->
            generateStarFromMatrix [ [ Current, Placeholder, Current ], [ Potential, Placeholder, Potential ] ]
          (2, 5) ->
            generateStarFromMatrix [ [ Current, Current, Potential ], [ Potential, Placeholder, Potential ] ]
          (2, 6) ->
            generateStarFromMatrix [ [ Current, Current, Potential ], [ Potential, Potential, Potential ] ]

          -- Current Ability of 3
          (3, 3) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Placeholder, Placeholder, Placeholder ] ]
          (3, 4) ->
            generateStarFromMatrix [ [ Current, Placeholder, Current ], [ Current, Placeholder, Potential ] ]
          (3, 5) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Potential, Placeholder, Potential ] ]
          (3, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Potential, Potential, Potential ] ]

          -- Current Ability of 4
          (4, 4) ->
            generateStarFromMatrix [ [ Current, Placeholder, Current ], [ Current, Placeholder, Current ] ]
          (4, 5) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Placeholder, Potential ] ]
          (4, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Potential, Potential ] ]

          -- Current Ability of 5
          (5, 5) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Placeholder, Current ] ]
          (5, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Current, Potential ] ]

          -- Current Ability of 6
          (6, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Current, Current ] ]


          -- All other cases
          (_, _ )-> 
            [ div [] [ StyledHtml.text "ERROR with player.ability or player.potential" ] ]

  in
  div [ class "star_content" ] stars