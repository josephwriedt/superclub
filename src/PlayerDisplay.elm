module PlayerDisplay exposing (..)
import Player exposing (..)
import Msg exposing (Msg)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Css exposing (position)
import Html.Styled.Attributes exposing (attribute, css, class)
import GameStyle
import Html.Styled.Events exposing (onClick)
import Html.Styled.Events exposing (onMouseDown)


playerStyle: PlayerOrPlaceholder -> Css.Style
playerStyle a =
  case a of
    PlayerPlaceholder _ -> 
      Css.display Css.none
    Player player ->
      case player.position of
        GK -> GameStyle.goalkeeperStyle
        DEF -> GameStyle.defenderStyle
        MID -> GameStyle.midfielderStyle
        ATT -> GameStyle.attackerStyle



playerToHtml: PlayerOrPlaceholder -> StyledHtml.Html msg
playerToHtml a =
  let
      textStyle = [ Css.color (Css.rgb 255 255 255)
                  , GameStyle.centerText
                  , Css.textAlign Css.textTop
                  ]
  in
  case a of
      PlayerPlaceholder _ -> div [] []
      Player player ->
        div 
          [ class player.name
          , css [ GameStyle.paddingStyle, Css.float Css.left ] 
          ] 
          [
            div 
            [ css  [ playerStyle a ]
            , class "player-card"
          --   , onMouseDown (Msg.Select { PlayerOrPlaceholder = PlayerOrPlaceholder })
            ]
            [ StyledHtml.h4 [ css textStyle ] [ text player.name ]
            , displayAbility a
            ]
          ]


-- Star Generation
type Star = StarPlaceholder | Current | Potential 

generateStar: Star -> StyledHtml.Html msg
generateStar star =
  case star of
    StarPlaceholder ->
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


displayAbility: PlayerOrPlaceholder -> StyledHtml.Html msg
displayAbility a = 
  let
      stars = 
        case (a |> ability, a |> potential) of
          -- Current Ability of 1
          (1, 1) ->
            generateStarFromMatrix [ [ StarPlaceholder, Current, StarPlaceholder ], [ StarPlaceholder, StarPlaceholder, StarPlaceholder ] ]
          (1, 2) -> 
            generateStarFromMatrix [ [ Current, StarPlaceholder, Potential ], [ StarPlaceholder, StarPlaceholder, StarPlaceholder ] ]
          (1, 3) ->
            generateStarFromMatrix [ [ Current, Potential, Potential ], [ StarPlaceholder, StarPlaceholder, StarPlaceholder ] ]
          (1, 4) ->
            generateStarFromMatrix [ [ Current, StarPlaceholder, Potential ], [ Potential, StarPlaceholder, Potential ] ]
          (1, 5) ->
            generateStarFromMatrix [ [ Current, Potential, Potential ], [ Potential, StarPlaceholder, Potential ] ]
          (1, 6) ->
            generateStarFromMatrix [ [ Current, Potential, Potential ], [ Potential, Potential, Potential ] ]
          
          -- Current Ability of 2
          (2, 2) ->
            generateStarFromMatrix [ [ Current, StarPlaceholder, Current ], [ StarPlaceholder, StarPlaceholder, StarPlaceholder ] ]
          (2, 3) ->
            generateStarFromMatrix [ [ Current, Current, Potential ], [ StarPlaceholder, StarPlaceholder, StarPlaceholder ] ]
          (2, 4) ->
            generateStarFromMatrix [ [ Current, StarPlaceholder, Current ], [ Potential, StarPlaceholder, Potential ] ]
          (2, 5) ->
            generateStarFromMatrix [ [ Current, Current, Potential ], [ Potential, StarPlaceholder, Potential ] ]
          (2, 6) ->
            generateStarFromMatrix [ [ Current, Current, Potential ], [ Potential, Potential, Potential ] ]

          -- Current Ability of 3
          (3, 3) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ StarPlaceholder, StarPlaceholder, StarPlaceholder ] ]
          (3, 4) ->
            generateStarFromMatrix [ [ Current, StarPlaceholder, Current ], [ Current, StarPlaceholder, Potential ] ]
          (3, 5) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Potential, StarPlaceholder, Potential ] ]
          (3, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Potential, Potential, Potential ] ]

          -- Current Ability of 4
          (4, 4) ->
            generateStarFromMatrix [ [ Current, StarPlaceholder, Current ], [ Current, StarPlaceholder, Current ] ]
          (4, 5) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, StarPlaceholder, Potential ] ]
          (4, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Potential, Potential ] ]

          -- Current Ability of 5
          (5, 5) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, StarPlaceholder, Current ] ]
          (5, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Current, Potential ] ]

          -- Current Ability of 6
          (6, 6) ->
            generateStarFromMatrix [ [ Current, Current, Current ], [ Current, Current, Current ] ]


          (0, 0) ->
            generateStarFromMatrix [ [], [] ]
          -- All other cases
          (_, _ )-> 
            [ div [] [ StyledHtml.text "ERROR with PlayerOrPlaceholder.ability or PlayerOrPlaceholder.potential" ] ]

  in
  div [ class "star_content" ] stars