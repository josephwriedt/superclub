module Model exposing (..)
import Club exposing (Club)
import Player exposing (PlayerOrPlaceholder, playerPlaceHolderName)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css
import List exposing (map)
import Msg exposing (Msg)
import Player exposing (PlayerOrPlaceholder(..))
import Array exposing (Array)
import Init
import Staff exposing (StaffOrPlaceholder(..))

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    Msg.ToggleFolder ->
      { model | folderOpen = not model.folderOpen, selectedSlot = Nothing }

    Msg.ChooseSlot slot ->
      case model.selectedSlot of
        Nothing -> { model | selectedSlot = Just slot }
        Just first -> { model | club = swapSlots first slot model.club, selectedSlot = Nothing }

    Msg.DragSlot slot ->
      { model | selectedSlot = Just slot }

    Msg.DropSlot slot ->
      case model.selectedSlot of
        Just first -> { model | club = swapSlots first slot model.club, selectedSlot = Nothing }
        Nothing -> model

    Msg.DragOver ->
      model

    Msg.CancelDrag ->
      { model | selectedSlot = Nothing }

    Msg.Increment ->
      model 

    Msg.Decrement ->
      model

    Msg.Select (player) ->
      model
    
    Msg.Swap player ->
      { model | swapPlayers = player :: model.swapPlayers } |> swapPlayersWithinClub

    Msg.Draft (player) ->
      model



-- VIEW
view : Model -> Html.Html Msg
view model =
    -- model |> squadView |>  toUnstyled
    Club.clubFolderHtml model.folderOpen model.club |> toUnstyled

    

squadView : Model -> StyledHtml.Html msg
squadView model = 
  let
      club = model.club
      squad = Club.squad club
  in
  

    StyledHtml.div
    [ css [  ] ]
    <| [ squadToHtml squad ]



-- MODEL
type alias Model = 
    { club : Club 
    , folderOpen : Bool
    , selectedSlot : Maybe Msg.Slot
    , swapPlayers : List PlayerOrPlaceholder
    }


 
init : Model
init =
  let
    reserves = Array.fromList Init.arsenalReserves
    starters = Array.fromList Init.arsenalStarters
      -- Array.initialize 20 (\n -> playerPlaceHolderName "starter" n)
    club = { balance = 100
           , stadium_level = Club.I
           , scouting_level = Club.I
           , training_level = Club.I
           , club_level = Club.NewlyPromoted
           , club_position = Club.Fifth
           , staff = Array.fromList [ StaffPlaceholder "staff-1", StaffPlaceholder "staff-2", StaffPlaceholder "staff-3" ]
           , reserves = reserves
           , starters = starters
           }
  in
  { club = club
  , folderOpen = False
  , selectedSlot = Nothing
  , swapPlayers = [] }


swapPlayersWithinClub: Model -> Model
swapPlayersWithinClub model =
  case List.length model.swapPlayers of
    2 -> 
      -- here we swap players
      model
    _ -> model



squadToHtml: List PlayerOrPlaceholder -> StyledHtml.Html msg
squadToHtml players = 
  let
    attributes = [ css 
                    [ Css.display Css.inlineFlex
                    , Css.flexFlow1 Css.wrap
                    ]
                  , class "squad"
                  ]

    squadHtml = map Player.playerToHtml players
  in
  StyledHtml.div attributes squadHtml



swapSlots : Msg.Slot -> Msg.Slot -> Club -> Club
swapSlots first second club =
  let
    get slot =
      case slot of
        Msg.Reserve index -> Array.get index club.reserves
        Msg.Starter index -> Array.get index club.starters
    set slot player current =
      case slot of
        Msg.Reserve index -> { current | reserves = Array.set index player current.reserves }
        Msg.Starter index -> { current | starters = Array.set index player current.starters }
  in
  case ( get first, get second ) of
    ( Just a, Just b ) -> club |> set first b |> set second a
    _ -> club
