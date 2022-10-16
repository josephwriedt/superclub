module Update exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Model exposing (modelSwapPlayers)

-- Helper Packages
import Random exposing (generate)
import Random.Extra exposing (maybe)
import Random.List
import Model exposing (modelNextGamePhase)


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NextGamePhase ->
      ( modelNextGamePhase model
      , Cmd.none
      )

    RandomDeckPlayer ->
      ( model, generate RandomPlayer (Random.List.choose model.playerDeck) )

    RandomPlayer (maybePlayer, playerList) ->
      ( { model | randomPlayer = maybePlayer, playerDeck = playerList }, Cmd.none )

    DraftNewPlayers (newDraftPlayers, playerList)  ->
      ( { model | playerDeck = playerList, draftPlayers = newDraftPlayers }, Cmd.none )

    ReshuffleDraft ->
      ( model, generate DraftNewPlayers (Random.List.choices 16 model.playerDeck ) )

    Drag player ->
      ( { model | beingDragged = Just player}
      , Cmd.none
      )
    
    DragEnd ->
      ( { model | beingDragged = Nothing } 
      , Cmd.none
      )

    DragOver ->
      ( model, Cmd.none )

    Drop player ->
     ( modelSwapPlayers model player
     , Cmd.none 
     ) 

    


