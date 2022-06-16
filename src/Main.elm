module Main exposing(..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Browser
import Html.Attributes exposing (start)
import Random
 
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
 
increaseAbility: Player -> Player
increaseAbility player = 
    if .ability player < .potential player then
        {player | ability = player.ability + 1}
    else 
        {player | ability = player.potential}

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
   
type FacilityLevel = I | II | III | IV

type alias Starters = 
  { goalkeeper : Player
  , defenders : List Player
  , midfielders : List Player
  , attackers : List Player
  }

validEleven: Starters -> Bool
validEleven starters =
  let

    d = List.length <| .defenders starters
    m = List.length <| .midfielders starters
    o = List.length <| .attackers starters
  in
  if d + m + o /= 10 then
      False
  else
    not <| List.member False 
      [ inRange starters.defenders 3 4
      , inRange starters.midfielders 3 5
      , inRange starters.attackers 2 4]

comparePlayers: List Player -> List Player -> Int
comparePlayers home away =
  clamp -1 1 
    <| lineStrength home - lineStrength away

type Winner = Home | Away | Tie
type Result = Win | Loss | Draw

-- TODO: Change this to use result instead of winner
playGame: Starters -> Starters -> Winner
playGame home away = 
  let
      mid = comparePlayers home.midfielders away.midfielders
      def = comparePlayers (home.goalkeeper :: home.defenders) away.attackers
      off = comparePlayers home.attackers (away.goalkeeper :: away.defenders)
      sum = mid + def + off
  in
  if sum > 0 then Home
  else if sum < 0 then Away
  else Tie

simGame: Int -> Int -> Result
simGame a b = 
  let
    sum = clamp 2 12 (a + b)
  in
  if sum <= 6 then 
    Loss
  else if sum <= 8 then 
    Draw
  else 
    Win

{-
Flow of game:
  OffSeason
    Income
      Stadium + Position
      Wages
    Training
      Select Players
        Roll
        Improved
    Scouting
      Draw Players
      Choose to Sign or not
    Investment
      Choose Facility
  Season

-}

type ClubLevel = NewlyPromoted | MidTable | Established | TitleContenders

type alias User = 
  { balance : Int
  , squad : List Player
  , starters : Starters
  , stadium_level : FacilityLevel
  , scouting_level : FacilityLevel
  , training_level : FacilityLevel
  , club_level : ClubLevel
  }
  
main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL
type alias Model = Player


init : Model
init =
  Player "John" DEF Both 1 3 10 5



-- UPDATE


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      increaseAbility model 

    Decrement ->
      model



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (playerToString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
