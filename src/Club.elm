module Club exposing (..)
import Player exposing (Player, comparePlayers, PlayerOrPlaceHolder)
import Array exposing (empty)
import Html.Attributes exposing (start)
import Msg exposing (Msg)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Css
import GameStyle
import PlayerDisplay

type Placement = First | Second | Third | Fourth | Fifth | Sixth
type ClubLevel = NewlyPromoted | MidTable | Established | TitleContenders
type FacilityLevel = I | II | III | IV
type Winner = Home | Away | Tie
type Result = Win | Loss | Draw


type alias Club = 
  { balance : Int
  , stadium_level : FacilityLevel
  , scouting_level : FacilityLevel
  , training_level : FacilityLevel
  , club_level : ClubLevel
  , club_position : Placement
  , attackers : List Player
  , midfielders : List Player
  , defenders : List Player
  , goalkeeper : Player
  , reserves : List Player
  }


toString: Club -> String
toString club = 
    String.join "\n"
    [ "Balance: " ++ String.fromInt club.balance 
    , "Squad: " ++ String.join ", " (List.map Player.playerToString <| squad club)
    ] 

-- type alias Starters = 
--   { goalkeeper : Player
--   , defenders : List Player
--   , midfielders : List Player
--   , attackers : List Player
--   }

-- validEleven: Starters -> Bool
-- validEleven starters =
--   let

--     d = List.length <| .defenders starters
--     m = List.length <| .midfielders starters
--     o = List.length <| .attackers starters
--   in
--   if d + m + o /= 10 then
--       False
--   else
--     not <| List.member False 
--       [ inRange starters.defenders 3 4
--       , inRange starters.midfielders 3 5
--       , inRange starters.attackers 2 4]

-- TODO: Change this to use result instead of winner
-- playGame: Starters -> Starters -> Winner
-- playGame home away = 
--   let
--       mid = comparePlayers home.midfielders away.midfielders
--       def = comparePlayers (home.goalkeeper :: home.defenders) away.attackers
--       off = comparePlayers home.attackers (away.goalkeeper :: away.defenders)
--       sum = mid + def + off
--   in
--   if sum > 0 then Home
--   else if sum < 0 then Away
--   else Tie

-- isPlayer: PlayerSlot -> Bool
-- isPlayer slot = 
--   case slot of
--     Player -> True
--     EmptySlot -> False


-- lengthPlayerSlots: List PlayerSlot -> Int
-- lengthPlayerSlots players = 
--   List.filter isPlayer players |> List.length


inRange: Int -> Int -> Int -> Bool
inRange players min max =
  (min <= players) && (players <= max)

startersValid: Club -> Bool
startersValid club = 
  let 
    attackers = inRange (club.attackers |> List.length) 2 4
    midfielders = inRange ( club.midfielders |> List.length) 3 5 
    defenders =  inRange (club.defenders |> List.length) 3 5
    goalkeeper = ([ club.goalkeeper ] |> List.length) == 1
    starters = List.map List.length [club.attackers, club.midfielders, club.defenders, [ club.goalkeeper ] ]
  in 
  (List.sum starters == 11)  && (List.any not [attackers, midfielders, defenders, goalkeeper])
    


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


squad: Club -> List Player
squad club =
  List.concat [club.attackers, club.midfielders, club.defenders, [ club.goalkeeper ], club.reserves]
  

squadStrength: Club -> Int
squadStrength club = 
  Player.sumAbility (squad club)


reservesToHtml: Club -> StyledHtml.Html Msg
reservesToHtml club = 
  let
      reserves = Player.sortPlayers club.reserves
      -- reservesHtml =   div [ css [ GameStyle.paddingStyle ] ] (List.map Player.playerToHtml reserves)
      attributes = [ css 
                      [ Css.display Css.inlineFlex
                      , Css.flexFlow1 Css.wrap
                      ]
                   , class "reserves"
                   ]
  in
  StyledHtml.div attributes (List.map PlayerDisplay.playerToHtml reserves)

attackersToHtml: Club -> StyledHtml.Html Msg
attackersToHtml club =
  let
      playersHtml = club.attackers |> List.map PlayerDisplay.playerToHtml
      attributes = [ css [ GameStyle.flexStyle 
                         , Css.flexFlow1 Css.wrap
                        --  , Css.width (Css.pct 30) 
                        --  , Css.height (Css.pct 20)
                         ] 
                   , class "attackers"
                   ]
  in
  StyledHtml.div attributes playersHtml


midfieldersToHtml: Club -> StyledHtml.Html Msg
midfieldersToHtml club = 
  let
      playersHtml = club.midfielders |> List.map PlayerDisplay.playerToHtml
      attributes = [ css [ GameStyle.flexStyle 
                         , Css.flexFlow1 Css.wrap 
                         ] 
                   , class "midfielders"
                   ]
  in
  StyledHtml.div attributes playersHtml


defendersToHtml: Club -> StyledHtml.Html Msg
defendersToHtml club = 
  let
      playersHtml = club.defenders |> List.map PlayerDisplay.playerToHtml
      attributes = [ css [ GameStyle.flexStyle 
                         , Css.flexFlow1 Css.wrap 
                         ] 
                   , class "defenders"      
                   ]
  in
  StyledHtml.div attributes playersHtml

goalkeeperToHtml: Club -> StyledHtml.Html Msg
goalkeeperToHtml club =
  let
      playersHtml = club.goalkeeper |> PlayerDisplay.playerToHtml
      attributes = [ css [ GameStyle.flexStyle 
                         , Css.flexFlow1 Css.wrap 
                         ] 
                   , class "goalkeeper"
                   ]
  in
  div attributes [ playersHtml ]
  -- StyledHtml.node "goalkeeper" attributes [ playersHtml ]

startersToHtml: Club -> StyledHtml.Html Msg
startersToHtml club = 
  let
    attackersHtml = attackersToHtml club
    midfieldersHtml = midfieldersToHtml club
    defendersHtml = defendersToHtml club
    goalkeepHtml = goalkeeperToHtml club
  in
  StyledHtml.div [ class "starters" ] [ attackersHtml, midfieldersHtml, defendersHtml, goalkeepHtml ]

clubFolderHtml: Club -> StyledHtml.Html Msg
clubFolderHtml club = 
  let
      reservesHtml = div [ css [ GameStyle.folderStyle, Css.float Css.left, Css.width (Css.pct 45) ] ] [ reservesToHtml club]
      startersHtml = div [ css [ GameStyle.folderStyle , Css.float Css.right, Css.width (Css.pct 45) ] ] [ startersToHtml club ]
      attributes = [ css 
                    [ Css.display Css.inlineFlex
                    , Css.flexFlow1 Css.wrap
                    -- , GameStyle.paddingStyle 
                    ]
                  ]
  in
  StyledHtml.node "player-folder" attributes [ reservesHtml, startersHtml ]