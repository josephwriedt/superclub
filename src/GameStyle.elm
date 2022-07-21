module GameStyle exposing (..)
import Css exposing (..)
import Html exposing (Attribute)
import Html.Styled.Attributes exposing (css)

cardStyles: List Style
cardStyles = 
    [ Css.border (px 10)
    , Css.padding (px 50)
    , Css.outlineStyle Css.solid
    , borderRadius (px 10)
    -- , height (pct 70)
    -- , width (pct 50)
    -- , width (px 822)
    -- , height (px 1122)
    -- , height (em 8.75)
    -- , width (em 6.25)
    ]

folderStyle: Style
folderStyle = 
    Css.batch [ Css.border (px 20) 
              , Css.outlineStyle Css.solid
              , borderRadius (px 20)
            --   , paddingStyle
              , width (pct 40)
              ]


goalkeeperStyle: Style
goalkeeperStyle = 
    let
        styles = Css.boxShadow4 (px 10) (px 10) (px 5) (rgb 252 103 3) :: cardStyles
    in
    
    Css.batch styles

defenderStyle: Style
defenderStyle = 
    let
        styles = Css.boxShadow4 (px 10) (px 10) (px 5) (rgb 247 58 25) :: cardStyles
    in
    
    Css.batch styles

midfielderStyle: Style
midfielderStyle = 
    let
        styles = Css.boxShadow4 (px 10) (px 10) (px 5) (rgb 252 227 3) :: cardStyles
    in
    
    Css.batch styles

attackerStyle: Style
attackerStyle = 
    let
        styles = Css.boxShadow4 (px 10) (px 10) (px 5) (rgb 13 168 26) :: cardStyles
    in
    
    Css.batch styles

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