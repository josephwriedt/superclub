module Model exposing (..)
import Club exposing (Club, swapPlayersInClub)
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
    , inspectedPlayer : PlayerOrPlaceholder
    , beingDragged : Maybe PlayerOrPlaceholder
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
    player = Player { name = "Nketiah", position = Player.ATT, chemistry = Player.Left, ability = 2, potential = 5, market_value = 25, scout_value = 15 } 
    model =   { club = club, swapPlayers = [], playerDeck = Init.playerDeck, randomPlayer = Nothing, inspectedPlayer = player, beingDragged = Nothing }
  in
  ( model
  , Cmd.none
  )


modelSwapPlayers : Model -> PlayerOrPlaceholder -> Model
modelSwapPlayers model playerB = 
  case model.beingDragged of
    Nothing -> 
      model
    Just playerA ->
      { model 
        | club =  swapPlayersInClub model.club playerA playerB
        , beingDragged = Nothing 
      }




