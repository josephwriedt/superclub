module Player exposing (..)
import Random
import Compare exposing (Comparator)
import Css exposing (position)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import GameStyle
import Msg exposing (Msg)
import Html.Styled.Events exposing (onClick)
import Msg exposing (Msg(..))

-- Types
type Position = GK | DEF | MID | ATT
type Chemistry = Left | Right | Both | None


-- Position
positionToString: Position -> String
positionToString pos = 
    case pos of 
        GK -> "Goalkeeper"
        DEF -> "Defender"
        MID -> "Midfielder"
        ATT -> "Attacker"

positionToInt: Position -> Int
positionToInt position =
  case position of
      GK -> 4
      DEF -> 3
      MID -> 2
      ATT -> 1


chemistryToString: Chemistry -> String
chemistryToString chem =
  case chem of 
    Left -> "Half Star on Card"
    Right -> "Right Half Star on Card"
    Both -> "Half Stars on Both Side of Card"
    None -> ""

roll: Random.Generator Int
roll = 
  Random.int 1 6

-- Player
type alias Player =
  { name : String
  , position : Position
  , chemistry : Chemistry
  , ability : Int
  , potential : Int
  , market_value : Int
  , scout_value : Int
  }

 
playerToString: Player -> String
playerToString player =
    String.join " " [.name player, String.fromInt <| .ability player, positionToString <| .position player]

playerPositionToInt: Player -> Int
playerPositionToInt player =
  player.position |> positionToInt

 
hasChemistry: Player -> Player -> Bool
hasChemistry a b =
  case (a.chemistry, b.chemistry) of
    (Right, Left) -> True
    (Right, Both) -> True
    (Both, Left) -> True
    (Both, Both) -> True
    (_, _) -> False
 
 
chemistryScore: List Player -> Int
chemistryScore line  =
  case line of
    l :: r :: rest ->
      if hasChemistry l r then
        1 + chemistryScore(r :: rest)
      else
        chemistryScore(r :: rest)
    _ ->
      0

sumAbility: List Player -> Int
sumAbility players =
  List.sum
    <| List.map .ability players
 
 
lineStrength: List Player -> Int
lineStrength players =
  sumAbility players + chemistryScore players
 


comparePlayers: List Player -> List Player -> Int
comparePlayers home away =
  clamp -1 1 
    <| lineStrength home - lineStrength away


-- Comparator for players
positionComparator: Comparator Player
positionComparator =
  Compare.by playerPositionToInt

currentAbilityComparator: Comparator Player
currentAbilityComparator =
  Compare.by .ability

potentialAbilityComparator: Comparator Player
potentialAbilityComparator = 
  Compare.by .potential

playerComparator: Comparator Player
playerComparator = 
  Compare.concat [ positionComparator, currentAbilityComparator, potentialAbilityComparator ]

sortPlayers: List Player -> List Player
sortPlayers players =
  players |> List.sortWith playerComparator

playerStyle: Player -> Css.Style
playerStyle player =
  case player.position of
    GK -> GameStyle.goalkeeperStyle
    DEF -> GameStyle.defenderStyle
    MID -> GameStyle.midfielderStyle
    ATT -> GameStyle.attackerStyle


playerToHtml: Player -> StyledHtml.Html Msg
playerToHtml player =
  div 
    [ class player.name
    , css [ GameStyle.paddingStyle ] 
    ] 
    [
        div 
        [ css  [ playerStyle player ]
        , class "player-card"
        ]
        [ StyledHtml.h4 [ css [ GameStyle.centerText, Css.textAlign Css.textTop ] ] [ text player.name ]
        , displayAbility player
        ]
    ]

type Star = Placeholder | Current | Potential 

generateStar: Star -> StyledHtml.Html Msg
generateStar star =
  case star of
    Placeholder ->
      StyledHtml.span [] []

    Current ->
      GameStyle.filledStar

    Potential ->
      GameStyle.unfilledStar

generateStarFromMatrix: List (List Star) -> List(StyledHtml.Html Msg)
generateStarFromMatrix matrix =
  let
      generateStarsRow list = 
        div [ class "star-row", css [ GameStyle.centerText ] ] 
          <| List.map generateStar list   
  in
  matrix |> List.map generateStarsRow


displayAbility: Player -> StyledHtml.Html Msg
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

  

-- playersToHtml: List Player -> StyledHtml.Html Msg
-- playersToHtml players =
--   let
--       playersHtml = List.map playerToHtml players
--       style = css []
--   in

  
