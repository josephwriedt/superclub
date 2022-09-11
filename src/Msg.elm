module Msg exposing (..)
import Player exposing (PlayerOrPlaceholder)

type Msg
  = Increment
  | Decrement
  | Select PlayerOrPlaceholder
  | Swap PlayerOrPlaceholder PlayerOrPlaceholder
  | PlayerA PlayerOrPlaceholder
  | PlayerB PlayerOrPlaceholder
  | Draft PlayerOrPlaceholder