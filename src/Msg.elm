module Msg exposing (..)
import Player exposing (Player)

type Msg
  = Increment
  | Decrement
  | Select { player : Player }
  | Swap { playerA : Player, playerB: Player }
  | PlayerA { playerA: Player }
  | PlayerB { playerB : Player }