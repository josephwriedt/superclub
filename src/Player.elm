module Player exposing (..)
import Random
import Compare exposing (Comparator)

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

type PlayerOrPlaceHolder 
  = Real Player
  | Placeholder String
 
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




