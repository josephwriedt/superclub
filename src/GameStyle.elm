module GameStyle exposing (..)
import Css exposing (..)
import Html exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Html.Styled as StyledHtml 
import Msg exposing (Msg)

cardStyles: List Style
cardStyles = 
    [ Css.border (px 10)
    , Css.padding (px 50)
    , Css.outlineStyle Css.solid
    , borderRadius (px 10)
    -- , width (pct 30)
    -- , height (pct 20)
    , Css.padding (pct 5)
    ]

folderStyle: Style
folderStyle = 
    Css.batch [ Css.border (px 20) 
              , Css.outlineStyle Css.solid
              , borderRadius (px 20)
            --   , paddingStyle
              , width (pct 40)
              , margin (pct 2.5)
              ]


goalkeeperStyle: Style
goalkeeperStyle = 
    let
        color = rgb 252 103 3
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles =  List.append [ backgroundColorStyle, boxShadowStyle ] cardStyles
    in
    
    Css.batch styles

defenderStyle: Style
defenderStyle = 
    let
        color = (rgb 247 58 25)
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = List.append [ backgroundColorStyle, boxShadowStyle ] cardStyles
    in
    
    Css.batch styles

midfielderStyle: Style
midfielderStyle = 
    let
        color = rgb 252 227 3
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = List.append [ backgroundColorStyle, boxShadowStyle ] cardStyles
    in
    
    Css.batch styles

attackerStyle: Style
attackerStyle = 
    let
        color = (rgb 13 168 26)
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = List.append [ backgroundColorStyle, boxShadowStyle ] cardStyles
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

-- exposing (Attribute, div, h2, h4, text, toUnstyled, span)

-- Stars 
filledStar: StyledHtml.Html Msg
filledStar = 
    let
        starString = String.fromChar (Char.fromCode 0x2605)
        styles = [ Css.fontSize (pct 100), color (rgb 255 255 255) ]
    in
    StyledHtml.span
        [ css styles]
        [ StyledHtml.text starString]
    
unfilledStar: StyledHtml.Html Msg
unfilledStar = 
    let 
        starString = String.fromChar (Char.fromCode 0x2606)
        styles = [ Css.fontSize (pct 100), color (rgb 255 255 255) ]
    in
    StyledHtml.span
        [ css styles]
        [ StyledHtml.text starString]
