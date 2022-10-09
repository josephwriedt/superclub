module Main exposing(..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Browser
import Html.Attributes exposing (start)
import Player exposing (PlayerOrPlaceholder)
import Model exposing (init, update, view)

{-
Flow of game:
  OffSeason
    Income
      Stadium 
      Position
      Wages
    Training
      Select Players
        Roll
        Improved
    Scouting
      Draw Players
      Choose to Sign or not
    Investment
      Choose Facility
  Season

-}
main =
  Browser.sandbox { init = init, update = update, view = view }






