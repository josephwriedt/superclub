module Msg exposing (..)
import Player exposing (PlayerOrPlaceholder)

type Msg
  = Increment
  | Decrement
  | Select PlayerOrPlaceholder
  | Swap PlayerOrPlaceholder
  | Draft PlayerOrPlaceholder
  | ToggleFolder
  | ChooseSlot Slot
  | DragSlot Slot
  | DropSlot Slot
  | CancelDrag
  | DragOver

type Slot = Reserve Int | Starter Int
