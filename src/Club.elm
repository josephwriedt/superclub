module Club exposing (..)
import Player exposing (PlayerOrPlaceholder, comparePlayers, Position)
import Array exposing (..)
import Html.Attributes exposing (start)
import Msg exposing (Msg)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Css
import Gamestyle
import Array
import Player exposing (isPlayer, playerEquality, playerId)
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
  , reserves : Array PlayerOrPlaceholder
  , starters : Array PlayerOrPlaceholder
  }

clubAttackers: Club -> Array PlayerOrPlaceholder
clubAttackers club =
  Array.slice 0 5 <| club.starters

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


clubSquad: Club -> List PlayerOrPlaceholder
clubSquad club =
  [ club.reserves, club.starters ] |> List.map Array.toList |> List.concat

  

clubSquadStrength: Club -> Int
clubSquadStrength club = 
  Player.sumAbility (clubSquad club)

findPlayerInArray : PlayerOrPlaceholder -> Array PlayerOrPlaceholder ->  Maybe Int
findPlayerInArray player playerArray =
  let 
    f controlPlayer (_, testPlayer) = playerEquality controlPlayer testPlayer
    playerComparison controlPlayer (index, indexPlayer) =
      if playerEquality controlPlayer indexPlayer
        then index
        else -1

    filteredList = List.filter (f player) (Array.toIndexedList playerArray)
    -- List.filterMap (playerComparison player) (Array.toIndexedList playerArray)
  in
  case List.length filteredList of
    0 -> Nothing
    _ -> case List.head filteredList of
        Just (index, _) -> Just index
        Nothing -> Nothing

swapPlayersInClub : Club -> PlayerOrPlaceholder -> PlayerOrPlaceholder -> Club
swapPlayersInClub club playerA playerB =
  let 
    len = Array.length club.starters
    squad = Array.append club.starters club.reserves
    
    indexA = findPlayerInArray playerA squad
    indexB = findPlayerInArray playerB squad
    swappedArray = case (indexA, indexB) of
      (Just a, Just b) ->
        squad |> Array.set a playerB |> Array.set b playerA
      (_, _) ->
        squad
  in
  { club | starters = Array.slice 0 len swappedArray, reserves = Array.slice len (Array.length swappedArray) swappedArray }
    
-- View for Club
reservesSliceToHtmlList : Array PlayerOrPlaceholder -> StyledHtml.Html Msg
reservesSliceToHtmlList players = 
  div 
    [ css [ Css.displayFlex, Css.flexFlow1 Css.noWrap ] ]
    (players |> Array.toList |> List.map PlayerDisplay.playerToHtmlDefault)
  


reservesToHtml : Club -> StyledHtml.Html Msg
reservesToHtml club =
  let
    reserves0 = Array.slice 0 5 club.reserves
    reserves1 = Array.slice 5 10 club.reserves
    reserves2 = Array.slice 10 15 club.reserves
  in
  StyledHtml.node "reserves" 
    []
    [ reserves0 |> reservesSliceToHtmlList
    , reserves1 |> reservesSliceToHtmlList
    , reserves2 |> reservesSliceToHtmlList
    ]

attackersToHtml: Club -> StyledHtml.Html Msg
attackersToHtml club =
  let
      playersHtml = clubAttackers club |> Array.toList |> List.map PlayerDisplay.playerToHtmlDefault
      attributes = [ css [ Css.displayFlex, Css.flexFlow1 Css.noWrap ] ]
  in
  StyledHtml.node "attack" attributes playersHtml


midfieldersToHtml: Club -> StyledHtml.Html Msg
midfieldersToHtml club = 
  let
      playersHtml = clubMidfielders club |> Array.toList |> List.map PlayerDisplay.playerToHtmlDefault
      attributes = [ css [ Css.displayFlex, Css.flexFlow1 Css.noWrap ] ]
  in
  StyledHtml.node "midfield" attributes playersHtml


defenseToHtml: Club -> StyledHtml.Html Msg
defenseToHtml club =
  let
      defendersHtml = (clubDefenders club |> Array.toList |> List.map PlayerDisplay.playerToHtmlDefault)
      goalkeeperHtml = clubGoalkeeper club |> PlayerDisplay.playerToHtmlDefault
      attributes = [ css [ Css.displayFlex, Css.flexFlow1 Css.noWrap ] ]
      playersHtml = goalkeeperHtml :: defendersHtml
  in
  StyledHtml.node "defense" attributes playersHtml
  

startersToHtml: Club -> StyledHtml.Html Msg
startersToHtml club = 
  let
    attackersHtml = attackersToHtml club
    midfieldersHtml = midfieldersToHtml club
    defenseHtml = defenseToHtml club
  in
  StyledHtml.node "starters" [] [ attackersHtml, midfieldersHtml, defenseHtml ]

clubFolderHtml: Club -> StyledHtml.Html Msg
clubFolderHtml club = 
  let
      reservesHtml = div [ css [ Gamestyle.folderStyle ] ] [ reservesToHtml club]
      startersHtml = div [ css [ Gamestyle.folderStyle ] ] [ startersToHtml club ]
      attributes = []
  in
  StyledHtml.node "player-folder" attributes [ reservesHtml, startersHtml ]