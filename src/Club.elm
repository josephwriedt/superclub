module Club exposing (..)
import Player exposing (PlayerOrPlaceholder, comparePlayers, Position)
import Array exposing (..)
import Html.Attributes exposing (start)
import Msg exposing (Msg)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Css
import GameStyle
import Array
import Player exposing (isPlayer)
import Staff exposing (StaffOrPlaceholder(..))

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
  , staff : Array StaffOrPlaceholder
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


slotToHtml : Float -> (Int -> Msg.Slot) -> Int -> PlayerOrPlaceholder -> StyledHtml.Html Msg
slotToHtml slotWidth slotType index player =
  let
    slot = slotType index
    label = if Player.isPlayer player then Player.name player else "Empty slot"
  in
  div
    [ css [ Css.width (Css.pct slotWidth), Css.property "flex" "1 1 0", Css.property "box-sizing" "border-box", Css.minWidth Css.zero ]
    , attribute "draggable" "true"
    , Events.on "dragstart" (Decode.succeed (Msg.DragSlot slot))
    , Events.on "dragend" (Decode.succeed Msg.CancelDrag)
    , Events.preventDefaultOn "dragover" (Decode.succeed ( Msg.DragOver, True ))
    , Events.preventDefaultOn "drop" (Decode.succeed ( Msg.DropSlot slot, True ))
    ]
    [ StyledHtml.button
        [ Events.onClick (Msg.ChooseSlot slot)
        , attribute "aria-label" ("Select " ++ label ++ " to move or swap")
        , css [ Css.border Css.zero, Css.padding Css.zero, Css.backgroundColor Css.transparent, Css.cursor Css.pointer, Css.width (Css.pct 100) ]
        ]
        [ Player.playerToHtml player ]
    ]


folderSlots : (Int -> Msg.Slot) -> Array PlayerOrPlaceholder -> StyledHtml.Html Msg
folderSlots slotType players =
  let
    row offset =
      div [ css [ Css.displayFlex, Css.flexWrap Css.noWrap, Css.property "gap" "8px", Css.marginBottom (Css.px 8) ] ]
        (players |> Array.toIndexedList |> List.drop offset |> List.take 5 |> List.map (\( index, player ) -> slotToHtml 20 slotType index player))
  in
  div [ css [ Css.overflowX Css.auto ] ] (List.map row [ 0, 5, 10 ])


reservesToHtml: Club -> StyledHtml.Html Msg
reservesToHtml club =
  let
    staffCard staff =
      let
        label = case staff of
          StaffMember member -> member.name ++ " — " ++ member.role
          StaffPlaceholder _ -> "Staff slot"
      in
      div
        [ css
            [ Css.width (Css.pct 20)
            , Css.property "flex" "1 1 0"
            , Css.property "box-sizing" "border-box"
            , Css.minWidth Css.zero
            ]
        ]
        [ div
            [ class "staff-card"
            , attribute "aria-label" label
            , css
                [ GameStyle.cardStyle
                , Css.backgroundColor (Css.hex "#b9def2")
                , Css.outlineStyle Css.dashed
                , Css.outlineWidth (Css.px 1)
                , Css.borderRadius (Css.px 8)
                , Css.textAlign Css.center
                ]
            ]
            [ text label ]
        ]
    row rowIndex =
      let
        players = club.reserves |> Array.toIndexedList |> List.drop (rowIndex * 4) |> List.take 4
        staff = Array.get rowIndex club.staff |> Maybe.map staffCard |> Maybe.withDefault (text "")
      in
      div [ css [ Css.displayFlex, Css.flexWrap Css.noWrap, Css.property "gap" "8px", Css.marginBottom (Css.px 8) ] ]
        (List.map (\( index, player ) -> slotToHtml 20 Msg.Reserve index player) players ++ [ staff ])
  in
  div
    [ class "reserves" ]
    (List.map row [ 0, 1, 2 ])

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
  folderSlots Msg.Starter club.starters

clubFolderHtml: Bool -> Club -> StyledHtml.Html Msg
clubFolderHtml isOpen club =
  let
      panel title background foreground content =
        StyledHtml.section
          [ css
              [ Css.flex (Css.int 1)
              , Css.property "box-sizing" "border-box"
              , Css.minWidth Css.zero
              , Css.flexBasis (Css.px 420)
              , Css.padding (Css.px 24)
              , Css.margin (Css.px 6)
              , Css.backgroundColor (Css.hex background)
              , Css.borderRadius (Css.px 6)
              ]
          ]
          [ h2 [ css [ Css.color (Css.hex foreground) ] ] [ text title ]
          , content
          ]
  in
  div
    [ class "club-folder"
    , css
        [ Css.margin (Css.px 24)
        , Css.padding (Css.px 20)
        , Css.backgroundColor (Css.hex "#aa7740")
        , Css.borderRadius (Css.px 12)
        , Css.boxShadow4 (Css.px 0) (Css.px 8) (Css.px 20) (Css.hex "#a39b8a")
        ]
    ]
    [ h2 [ css [ Css.color (Css.hex "#fff8e8"), Css.marginBottom (Css.px 16) ] ] [ text "Brown Team" ]
    , div
        [ css [ Css.position Css.relative, Css.overflow Css.hidden, Css.borderRadius (Css.px 8) ] ]
        [ div
            [ attribute "id" "folder-contents"
            , css
                [ Css.displayFlex
                , Css.flexWrap Css.wrap
                , Css.padding (Css.px 12)
                , Css.backgroundColor (Css.hex "#80552e")
                , Css.property "visibility" (if isOpen then "visible" else "hidden")
                ]
            ]
            [ panel "Reserves" "#f8f2df" "#493d2d" (reservesToHtml club)
            , panel "Starting lineup" "#173451" "#ffffff" (startersToHtml club)
            ]
        , div
            [ attribute "aria-hidden" "true"
            , css
                [ Css.position Css.absolute
                , Css.property "inset" "0"
                , Css.backgroundColor (Css.hex "#9b6938")
                , Css.borderRadius (Css.px 8)
                , Css.property "transform-origin" "left center"
                , Css.property "transform" (if isOpen then "scaleX(0)" else "scaleX(1)")
                , Css.property "transition" "transform 300ms ease"
                , Css.property "pointer-events" "none"
                ]
            ]
            []
        ]
    ]


clubInfoToHtml : Club -> StyledHtml.Html Msg
clubInfoToHtml _ =
  StyledHtml.section [ css [ Css.margin (Css.px 24), Css.padding (Css.px 24) ] ]
    [ h2 [] [ text "Club info" ]
    , StyledHtml.p [] [ text "Club information is not available yet." ]
    ]
