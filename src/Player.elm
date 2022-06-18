module Player exposing (..)
import Random
import Html exposing (Html, div)

-- Types
type Position = GK | DEF | MID | ATT
type Chemistry = Left | Right | Both | None


-- Position
positionToString: Position -> String
positionToString pos = 
    case pos of 
        GK -> "GoalKeeper"
        DEF -> "Defender"
        MID -> "Midfielder"
        ATT -> "Attacker"

chemistryToString: Chemistry -> String
chemistryToString chem =
  case chem of 
    Left -> "Half Star on Card"
    Right -> "Right Half Star on Card"
    Both -> "Half Stars on Both Side of Card"
    None -> ""

-- chemistryToHtml: 

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

 
hasChemistry: Player -> Player -> Bool
hasChemistry a b =
  case (a.chemistry, b.chemistry) of
    (Right, Left) -> True
    (Right, Both) -> True
    (Both, Left) -> True
    (Both, Both) -> True
    (_, _) -> False
 
 
chemistryScore: List Player -> Int
chemistryScore line =
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
 
inRange: List Player -> Int -> Int -> Bool
inRange players min max =
  min <= List.length players && List.length players <= max

comparePlayers: List Player -> List Player -> Int
comparePlayers home away =
  clamp -1 1 
    <| lineStrength home - lineStrength away