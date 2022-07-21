module Player exposing (..)
import Random
import Compare exposing (Comparator)
import Css exposing (position)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import GameStyle
import Msg exposing (Msg)

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
        [ h2 [ css [ GameStyle.centerText, Css.textAlign Css.textTop ] ] [ text player.name ]
        , h4 [] [ player.position |> positionToString |> text ]
        , h4 [] [ player.chemistry |> chemistryToString |> text ]
        , h4 [] [ text (String.fromInt player.ability ++ " out of " ++ String.fromInt player.potential) ]
        
        ]
    ]
