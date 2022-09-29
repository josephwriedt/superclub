module Model exposing (..)
import Club exposing (Club)
import Player exposing (PlayerOrPlaceholder, playerPlaceHolderName)
import List exposing (map)
import Msg exposing (Msg)
import Player exposing (PlayerOrPlaceholder(..))
import Array exposing (Array)
import Init


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- MODEL
type alias Model = 
    { club : Club 
    , swapPlayers : List PlayerOrPlaceholder
    , playerDeck : List PlayerOrPlaceholder
    , randomPlayer : Maybe PlayerOrPlaceholder
    }


 
init : () -> (Model, Cmd Msg)
init _ =
  let
    reserves = Array.fromList Init.arsenalReserves
    starters = Array.fromList Init.arsenalStarters
      -- Array.initialize 20 (\n -> playerPlaceHolderName "starter" n)
    club =  { balance = 0
            , stadium_level = Club.I
            , scouting_level = Club.I
            , training_level = Club.I
            , club_level = Club.NewlyPromoted
            , club_position = Club.Fifth
            , reserves = reserves
            , starters = starters
            }
    model =   { club = club, swapPlayers = [], playerDeck = Init.playerDeck, randomPlayer = Nothing }
  in
  ( model
  , Cmd.none
  )


swapPlayersWithinClub: Model -> Model
swapPlayersWithinClub model =
  case List.length model.swapPlayers of
    2 -> 
      -- here we swap players
      model
    _ -> model



