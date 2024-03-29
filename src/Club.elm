module Club exposing (..)
import Player exposing (PlayerOrPlaceholder, comparePlayers, Position)
import Array exposing (..)
import Html.Attributes exposing (start)
import Msg exposing (Msg)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Css
import GameStyle
import Array
import Player exposing (isPlayer)

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
  , reserves : Array PlayerOrPlaceholder
  , starters : Array PlayerOrPlaceholder
  }

clubAttackers: Club -> Array PlayerOrPlaceholder
clubAttackers club =
  Array.slice 0 5 club.starters

clubMidfielders: Club -> Array PlayerOrPlaceholder
clubMidfielders club = 
  Array.slice 5 10 club.starters

clubDefenders: Club -> Array PlayerOrPlaceholder
clubDefenders club =
  Array.slice 11 15 club.starters

clubGoalkeeper: Club -> PlayerOrPlaceholder
clubGoalkeeper club =
  case Array.get 10 club.starters of
    Just player -> player
    Nothing -> Player.defaultGoalkeeper
  

toString: Club -> String
toString club = 
    String.join "\n"
    [ "Balance: " ++ String.fromInt club.balance 
    , "Squad: " ++ String.join ", " (List.map Player.playerToString <| squad club)
    ] 

inRange: Int -> Int -> Int -> Bool
inRange players min max =
  (min <= players) && (players <= max)

startersValid: Club -> Bool
startersValid club = 
  let 
    attackers = inRange (clubAttackers club |> Array.filter isPlayer |>  Array.length) 2 4
    midfielders = inRange (clubMidfielders club |> Array.filter isPlayer |> Array.length) 3 5 
    defenders =  inRange (clubDefenders club |> Array.filter isPlayer |> Array.length) 3 5
    goalkeeper = case clubGoalkeeper club |> Player.position of
                    Just pos -> pos == Player.GK
                    Nothing -> False
    startersLength = (Array.filter isPlayer club.starters |> Array.length) == 11
  in 
  List.any not [ attackers, midfielders, defenders, goalkeeper, startersLength ]
    


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


squad: Club -> List PlayerOrPlaceholder
squad club =
  [ club.reserves, club.starters ] |> List.map Array.toList |> List.concat

  

squadStrength: Club -> Int
squadStrength club = 
  Player.sumAbility (squad club)


reservesToHtml: Club -> StyledHtml.Html Msg
reservesToHtml club = 
  let
      reserves = club.reserves
      attributes = [ css 
                      [ Css.display Css.inlineFlex
                      , Css.flexFlow1 Css.wrap
                      ]
                   , class "reserves"
                   ]
  in
  StyledHtml.div attributes <| Array.toList (Array.map Player.playerToHtml reserves)

attackersToHtml: Club -> StyledHtml.Html Msg
attackersToHtml club =
  let
      playersHtml = clubAttackers club |> Array.toList |> List.map Player.playerToHtml
      attributes = [ css [ GameStyle.flexStyle 
                         , Css.flexFlow1 Css.wrap
                         ] 
                   , class "attackers"
                   ]
  in
  StyledHtml.div attributes playersHtml


midfieldersToHtml: Club -> StyledHtml.Html Msg
midfieldersToHtml club = 
  let
      playersHtml = clubMidfielders club |> Array.toList |> List.map Player.playerToHtml
      attributes = [ css [ GameStyle.flexStyle 
                         , Css.flexFlow1 Css.wrap 
                         ] 
                   , class "midfielders"
                   ]
  in
  StyledHtml.div attributes playersHtml


defenseToHtml: Club -> StyledHtml.Html Msg
defenseToHtml club =
  let
      defendersHtml = StyledHtml.div [ class "defenders" ] (clubDefenders club |> Array.toList |> List.map Player.playerToHtml)
      goalkeeperHtml = StyledHtml.div [ class "goalkeeper" ] [ clubGoalkeeper club |> Player.playerToHtml ] 
      attributes = [ css [ GameStyle.flexStyle, Css.flexFlow1 Css.wrap ] ]
      playersHtml = [ goalkeeperHtml, defendersHtml ]
  in
  StyledHtml.div attributes playersHtml
  

defendersToHtml: Club -> StyledHtml.Html Msg
defendersToHtml club = 
  let
      playersHtml = clubDefenders club |> Array.toList |> List.map Player.playerToHtml
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
      playersHtml = clubGoalkeeper club |> Player.playerToHtml
      attributes = [ css [ GameStyle.flexStyle 
                         , Css.flexFlow1 Css.wrap 
                         ] 
                   , class "goalkeeper"
                   ]
  in
  div attributes [ playersHtml ]

startersToHtml: Club -> StyledHtml.Html Msg
startersToHtml club = 
  let
    attackersHtml = attackersToHtml club
    midfieldersHtml = midfieldersToHtml club
    defenseHtml = defenseToHtml club
  in
  StyledHtml.div [ class "starters" ] [ attackersHtml, midfieldersHtml, defenseHtml ]

clubFolderHtml: Club -> StyledHtml.Html Msg
clubFolderHtml club = 
  let
      reservesHtml = div [ css [ GameStyle.folderStyle, Css.float Css.left, Css.width (Css.pct 45) ] ] [ reservesToHtml club]
      startersHtml = div [ css [ GameStyle.folderStyle , Css.float Css.right, Css.width (Css.pct 45) ] ] [ startersToHtml club ]
      attributes = [ css 
                    [ Css.display Css.inlineFlex
                    , Css.flexFlow1 Css.wrap
                    ]
                  ]
  in
  StyledHtml.node "PlayerOrPlaceholder-folder" attributes [ reservesHtml, startersHtml ]