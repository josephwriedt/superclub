module Player exposing (..)
import Random
import Compare exposing (Comparator)

-- Types
type Position = GK | DEF | MID | ATT 
type Chemistry = Left | Right | Both | NoChemistry


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
    NoChemistry -> ""

roll: Random.Generator Int
roll = 
  Random.int 1 6

-- Player
-- type alias Player =
--   { name : String
--   , position : Position
--   , chemistry : Chemistry
--   , ability : Int
--   , potential : Int
--   , market_value : Int
--   , scout_value : Int
--   }

defaultGoalkeeper: PlayerOrPlaceholder
defaultGoalkeeper = 
  Player {
    name = "Woods",
    position = GK,
    chemistry = NoChemistry,
    ability = 1,
    potential = 1,
    market_value = 0,
    scout_value = 0
  }

type PlayerOrPlaceholder 
  = Player { name : String
           , position : Position
           , chemistry : Chemistry
           , ability : Int
           , potential : Int
           , market_value : Int
           , scout_value : Int
           }
  | PlayerPlaceholder String

playerId: PlayerOrPlaceholder -> String
playerId a = 
  case a of
    Player player ->
      player.name
    PlayerPlaceholder id ->
      id


name: PlayerOrPlaceholder -> String
name a =
  case a of
    Player player -> player.name
    PlayerPlaceholder _ -> ""

potential: PlayerOrPlaceholder -> Int
potential a =
  case a of
    PlayerPlaceholder _ -> 0
    Player player -> .potential player

ability: PlayerOrPlaceholder -> Int
ability a = 
  case a of
    PlayerPlaceholder _ -> 0
    Player player ->
      player.ability

chemistry: PlayerOrPlaceholder -> Chemistry
chemistry a = 
  case a of
    PlayerPlaceholder _ -> 
      NoChemistry
    Player player ->
      player.chemistry


isPlayer: PlayerOrPlaceholder -> Bool
isPlayer a = 
  case a of
    PlayerPlaceholder _ -> False
    Player _ -> True


playerToString: PlayerOrPlaceholder -> String
playerToString a =
  case a of
    PlayerPlaceholder id -> "placeholder-" ++ id
    Player player ->
      String.join " " [.name player, String.fromInt <| .ability player, positionToString <| .position player]

playerPositionToInt: PlayerOrPlaceholder -> Int
playerPositionToInt a =
  case a of
    PlayerPlaceholder _ -> 0
    Player player ->
      player.position |> positionToInt



hasChemistry: PlayerOrPlaceholder -> PlayerOrPlaceholder -> Bool
hasChemistry a b =
  case (a |> chemistry, b |> chemistry) of
    (Right, Left) -> True
    (Right, Both) -> True
    (Both, Left) -> True
    (Both, Both) -> True
    (_, _) -> False
 
 
chemistryScore: List PlayerOrPlaceholder -> Int
chemistryScore line  =
  case line of
    l :: r :: rest ->
      if hasChemistry l r then
        1 + chemistryScore(r :: rest)
      else
        chemistryScore(r :: rest)
    _ ->
      0

sumAbility: List PlayerOrPlaceholder -> Int
sumAbility players =
  List.sum
    <| List.map ability 
    <| List.filter isPlayer players
 
 
lineStrength: List PlayerOrPlaceholder -> Int
lineStrength players =
  sumAbility players + chemistryScore players

comparePlayers: List PlayerOrPlaceholder -> List PlayerOrPlaceholder -> Int
comparePlayers home away =
  clamp -1 1 
    <| lineStrength home - lineStrength away


-- Comparator for players
positionComparator: Comparator PlayerOrPlaceholder
positionComparator =
  Compare.by playerPositionToInt

currentAbilityComparator: Comparator PlayerOrPlaceholder
currentAbilityComparator =
  Compare.by ability

potentialAbilityComparator: Comparator PlayerOrPlaceholder
potentialAbilityComparator = 
  Compare.by potential

playerComparator: Comparator PlayerOrPlaceholder
playerComparator = 
  Compare.concat [ positionComparator, currentAbilityComparator, potentialAbilityComparator ]

sortPlayers: List PlayerOrPlaceholder -> List PlayerOrPlaceholder
sortPlayers players =
  players |> List.sortWith playerComparator




