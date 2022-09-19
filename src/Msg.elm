module Msg exposing (..)
import Player exposing (PlayerOrPlaceholder)

type Msg
  = Increment
  | Decrement
  | Select PlayerOrPlaceholder
  | Swap PlayerOrPlaceholder
  | Draft PlayerOrPlaceholder