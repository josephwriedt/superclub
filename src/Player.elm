module Player exposing (..)
import Compare exposing (Comparator)
import Html exposing (a)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Css exposing (position)
import Html.Styled.Attributes exposing (attribute, css, class)
import GameStyle


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
positionToInt pos =
  case pos of
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

-- Generate Player or PlayerPlaceholder
playerPlaceHolderName: String -> Int -> PlayerOrPlaceholder
playerPlaceHolderName positionName id =
  String.join "-" [ positionName, String.fromInt id ] |> PlayerPlaceholder 

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

-- Get attributes from PlayerOrPlaceholder Type
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

position: PlayerOrPlaceholder -> Maybe Position
position a = 
  case a of 
    Player player -> Just player.position
    PlayerPlaceholder _ -> Nothing

chemistry: PlayerOrPlaceholder -> Chemistry
chemistry a = 
  case a of
    PlayerPlaceholder _ -> 
      NoChemistry
    Player player ->
      player.chemistry


-- Functions on PlayerOrPlaceholder
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


-- Functions between PlayerOrPlaceholder types
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



