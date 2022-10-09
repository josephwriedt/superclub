module Msg exposing (..)
import Player exposing (PlayerOrPlaceholder)
import Html.Styled.Events as Events
import Json.Decode as Decode

type Msg
  = Increment
  | Decrement
  | Select PlayerOrPlaceholder
  | Swap PlayerOrPlaceholder
  | RandomDeckPlayer
  | RandomPlayer (Maybe PlayerOrPlaceholder, List PlayerOrPlaceholder)
  | Draft PlayerOrPlaceholder
  | Drag PlayerOrPlaceholder
  | DragEnd
  | DragOver
  | Drop PlayerOrPlaceholder

-- From Example: https://benpaulhanna.com/basic-html5-drag-and-drop-with-elm.html, https://ellie-app.com/7S7rMbddYYVa1
onDragStart msg =
  Events.on "dragstart"
    <| Decode.succeed msg

onDragEnd msg = 
  Events.on "dragend"
    <| Decode.succeed msg

onDragOver msg =
  Events.preventDefaultOn "dragover"
    <| Decode.succeed (msg, True)

onDrop msg = 
  Events.preventDefaultOn "drop"
    <| Decode.succeed (msg, True)