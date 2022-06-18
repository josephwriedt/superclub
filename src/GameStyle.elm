module GameStyle exposing (..)
import Css exposing (..)
import Html exposing (Attribute)
import Model exposing (Msg)
import Html.Styled.Attributes exposing (css)

cardStyle: Style
cardStyle = 
    Css.batch 
    [ Css.boxShadow4 (px 10) (px 10) (px 5) (rgb 211 121 112)
    , Css.border (px 10)
    , Css.padding (px 50)
    , Css.outlineStyle Css.solid
    , borderRadius (px 10)
    , width (px 100)
    , height (px 350)
    ]

paddingStyle: Style
paddingStyle = 
    Css.batch 
    [ Css.padding (px 50)
    , cardDisplayStyle
    ]

cardDisplayStyle: Style
cardDisplayStyle = 
    display inlineBlock
    
cardDisplayAttribtue : Attribute Msg
cardDisplayAttribtue = 
    css [ cardDisplayStyle ]
