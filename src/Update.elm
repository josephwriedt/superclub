module Update exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Model exposing (modelSwapPlayers)

-- Helper Packages
import Random exposing (generate)
import Random.Extra exposing (maybe)
import Random.List


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      ( model 
      , Cmd.none
      )

    Decrement ->
      ( model 
      , Cmd.none
      )

    Select (player) ->
      ( model 
      , Cmd.none
      )
    
    Swap player ->
      ( model
      , Cmd.none
      )

    Draft (player) ->
      ( model 
      , Cmd.none
      )

    RandomDeckPlayer ->
      ( model, generate RandomPlayer (Random.List.choose model.playerDeck) )

    RandomPlayer (maybePlayer, playerList) ->
      ( { model | randomPlayer = maybePlayer, playerDeck = playerList }, Cmd.none )

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

    


