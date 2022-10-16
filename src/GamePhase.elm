module GamePhase exposing (..)

-- Display Packages
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html.Styled.Keyed as KHtml
import Css exposing (..)
-- Helper Packages
import List exposing (map)
import Msg exposing (Msg)
import Html.Styled.Events exposing (onClick)


type GamePhase 
    = Draft
    | Offseason
    | Season

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

phaseToString : GamePhase -> String
phaseToString phase = 
    case phase of
        Draft -> "draft"
        Offseason -> "offseason"
        Season -> "season"

nextPhase : GamePhase -> GamePhase
nextPhase phase =
    case phase of
        Draft -> Offseason
        Offseason -> Season
        Season -> Offseason

-- phaseToTimelineHtml : GamePhase -> Html.Html Msg
-- phaseToTimelineHtml phase = 
--     KHtml.node "div"
--             []
--             [ ( phase |> phaseToString
--               , Html.div
--                     [ css
--                         [ Css.marginBottom <| Css.rem 1 ]
--                     ]
--                     [ Html.header
--                         [ css
--                             [ Css.displayFlex
--                             , Css.alignItems Css.center
--                             , Css.marginBottom <| Css.rem 0.5
--                             ]
--                         ]
--                         [ Placeholders.Circle.view circle
--                         , Placeholders.Rectangle.view rectangle
--                         ]
--                     , Html.div
--                         [ css
--                             [ Css.marginLeft <| Css.px 48 ]
--                         ]
--                         [ Placeholders.Block.view block ]
--                     ]
--               )
--             ]


-- gamePhaseToHtml : GamePhase -> Html.Html Msg
-- gamePhaseToHtml phase = 
--     Html.node "game-phase" 
--         [ Html.css
--             [ Css.position Css.relative ]
--         ]
--         [ -- The vertical line
--           Html.div
--             [ css
--                 [ Css.borderRight3 (Css.px 2) Css.solid (Css.hex "EFEFEF")
--                 , Css.position Css.absolute
--                 , Css.top Css.zero
--                 , Css.left <| Css.px 16
--                 , Css.height <| Css.pct 100
--                 ]
--             ]
--             []
--         , phase |> phaseToTimelineHtml
--         ] 