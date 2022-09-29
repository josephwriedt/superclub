module Msg exposing (..)
import Player exposing (PlayerOrPlaceholder)

type Msg
  = Increment
  | Decrement
  | Select PlayerOrPlaceholder
  | Swap PlayerOrPlaceholder
  | RandomDeckPlayer
  | RandomPlayer (Maybe PlayerOrPlaceholder, List PlayerOrPlaceholder)
  | Draft PlayerOrPlaceholder