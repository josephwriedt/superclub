module GameFlow exposing (Step(..), next, sidebar)

import Css
import Html.Styled as Html exposing (Html, div, li, nav, ol, text)
import Html.Styled.Attributes exposing (attribute, css)


type Step
    = Draft
    | Stadium
    | Position
    | Wages
    | SelectPlayers
    | Roll
    | Improved
    | DrawPlayers
    | SignDecision
    | ChooseFacility
    | Season


next : Step -> Step
next step =
    case step of
        Draft -> Stadium
        Stadium -> Position
        Position -> Wages
        Wages -> SelectPlayers
        SelectPlayers -> Roll
        Roll -> Improved
        Improved -> DrawPlayers
        DrawPlayers -> SignDecision
        SignDecision -> ChooseFacility
        ChooseFacility -> Season
        Season -> Stadium


sidebar : Step -> Html msg
sidebar current =
    let
        item step label =
            li
                ([ css
                    [ Css.padding2 (Css.px 9) (Css.px 12)
                    , Css.marginBottom (Css.px 2)
                    , Css.borderRadius (Css.px 7)
                    , Css.backgroundColor (Css.hex (if step == current then "#0142aa" else "#101b2b"))
                    , Css.color (Css.hex (if step == current then "#ffffff" else "#a9b7c9"))
                    ]
                 ]
                    ++ (if step == current then [ attribute "aria-current" "step" ] else [])
                )
                [ text label ]

        group label items =
            li []
                [ Html.node "details" []
                    [ Html.node "summary" [ css [ Css.cursor Css.pointer, Css.property "direction" "rtl", Css.textAlign Css.left, Css.padding2 (Css.px 9) (Css.px 12), Css.color (Css.hex "#c3cfdd"), Css.borderRadius (Css.px 7) ] ] [ text label ]
                    , ol [ css [ Css.paddingLeft (Css.px 14), Css.marginTop Css.zero, Css.property "list-style" "none" ] ] items
                    ]
                ]
    in
    nav
        [ attribute "aria-label" "Game flow"
        , css
            [ Css.flexShrink (Css.int 0)
            , Css.padding (Css.px 18)
            , Css.backgroundColor (Css.hex "#060b12")
            , Css.color (Css.hex "#e9f0fa")
            , Css.borderRadius (Css.px 12)
            , Css.margin (Css.px 12)
            , Css.property "font-family" "system-ui, sans-serif"
            , Css.property "box-shadow" "0 12px 30px rgba(6, 11, 18, 0.2)"
            , Css.property "box-sizing" "border-box"
            ]
        ]
        [ Html.node "details" []
            [ Html.node "summary" [ css [ Css.cursor Css.pointer, Css.property "direction" "rtl", Css.textAlign Css.left, Css.fontSize (Css.px 18), Css.padding2 (Css.px 10) (Css.px 12), Css.color (Css.hex "#ffffff") ] ] [ text "Game flow" ]
            , div [ css [ Css.width (Css.px 220), Css.property "max-width" "calc(100vw - 40px)" ] ]
                [ ol [ css [ Css.paddingLeft Css.zero, Css.property "list-style" "none" ] ]
                    [ item Draft "Draft"
                    , group "Offseason"
                        [ group "Income" [ item Stadium "Stadium", item Position "Position", item Wages "Wages" ]
                        , group "Training" [ item SelectPlayers "Select players", group "Training outcome" [ item Roll "Roll", item Improved "Improved" ] ]
                        , group "Scouting" [ item DrawPlayers "Draw players", item SignDecision "Choose to sign or not" ]
                        , group "Investment" [ item ChooseFacility "Choose facility" ]
                        ]
                    , item Season "Season"
                    ]
                ]
            ]
        ]
