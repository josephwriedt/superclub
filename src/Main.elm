module Main exposing(..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Browser
 
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


validEleven: Player -> List Player -> List Player -> List Player -> Bool
validEleven goalkeeper defense midfield offense =
  let
    d = List.length defense
    m = List.length midfield
    o = List.length offense
  in
  if d + m + o /= 11 then
      False
  else
    not <| List.member False [inRange defense 3 4, inRange midfield 3 5, inRange offense 2 4]
   
  
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
