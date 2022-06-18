module Club exposing (..)
import Player exposing (Player, inRange, comparePlayers)

type Placement = First | Second | Third | Fourth | Fifth | Sixth
type ClubLevel = NewlyPromoted | MidTable | Established | TitleContenders
type FacilityLevel = I | II | III | IV
type Winner = Home | Away | Tie
type Result = Win | Loss | Draw


type alias Club = 
  { balance : Int
  , squad : List Player
  , starters : Starters
  , stadium_level : FacilityLevel
  , scouting_level : FacilityLevel
  , training_level : FacilityLevel
  , club_level : ClubLevel
  , club_position : Placement
  }
  

toString: Club -> String
toString a = 
    String.join "\n"
    [ "Balance: " ++ String.fromInt a.balance 
    , "Squad: " ++ String.join ", " (List.map Player.playerToString a.squad)
    ] 

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

squadStrength: Club -> Int
squadStrength a =
    Player.sumAbility a.squad