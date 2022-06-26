module GameStyle exposing (..)
import Css exposing (..)
import Html exposing (Attribute)
import Html.Styled.Attributes exposing (css)

cardStyle: Style
cardStyle = 
    Css.batch 
    [ Css.boxShadow4 (px 10) (px 10) (px 5) (rgb 211 121 112)
    , Css.border (px 10)
    , Css.padding (px 50)
    , Css.outlineStyle Css.solid
    , borderRadius (px 10)
    , height (pct 70)
    , width (pct 50)
    -- , width (px 100)
    -- , height (px 350)
    , height (em 8.75)
    , width (em 6.25)
    ]

paddingStyle: Style
paddingStyle = 
    Css.batch 
    [ 
        Css.padding (px 10)
        -- Css.padding (pct 5)
    ]

centerText: Style
centerText = 
    textAlign center