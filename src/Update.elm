module Update exposing (..)
import Model exposing (Model, swapPlayersWithinClub)
import Msg exposing (Msg(..))

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
      ( { model | swapPlayers = player :: model.swapPlayers } |> swapPlayersWithinClub
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


