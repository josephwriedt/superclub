module Main exposing(..)

import Html exposing (Html, button, div, text)
import Browser
import Html.Attributes exposing (start)
import Player exposing (PlayerOrPlaceholder)
import Model exposing (init, subscriptions)
import View exposing (view)
import Update exposing (update)

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
  Browser.element { init = init
                  , view = view
                  , update = update
                  , subscriptions = subscriptions
                  }





