module Gamestyle exposing (..)
import Css exposing (..)
import Html exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Html.Styled as StyledHtml 

cardDimensions : Style
cardDimensions =
    Css.batch [ width (inches 1.25)
              , height (inches 1.75)
              ]


cardStyle : Style
cardStyle = 
    Css.batch 
        [ Css.border (px 10)
        , Css.padding (px 50)
        , Css.outlineStyle Css.solid
        , borderRadius (px 10)
        , Css.padding (pct 5)
        , cardDimensions
        ]

folderStyle : Style
folderStyle = 
    Css.batch [ Css.border (px 20) 
              , Css.outlineStyle Css.solid
              , borderRadius (px 20)
              , margin (pct 2.5)
              ]

playerPlaceholderStyle : Style
playerPlaceholderStyle = 
    let
        color = (hex "#e0e0e0")
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = [ backgroundColorStyle, boxShadowStyle, cardStyle ]
    in
    Css.batch styles

goalkeeperStyle : Style
goalkeeperStyle = 
    let
        color = rgb 252 103 3
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles =  [ backgroundColorStyle, boxShadowStyle, cardStyle ] 
    in
    
    Css.batch styles

defenderStyle : Style
defenderStyle = 
    let
        color = (hex "#e01e26")
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = [ backgroundColorStyle, boxShadowStyle, cardStyle ] 
    in
    
    Css.batch styles

midfielderStyle : Style
midfielderStyle = 
    let
        color = (hex "#fcc800")
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = [ backgroundColorStyle, boxShadowStyle, cardStyle ] 
    in
    
    Css.batch styles

attackerStyle : Style
attackerStyle = 
    let
        color = (hex "#00913c")
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = [ backgroundColorStyle, boxShadowStyle, cardStyle ]
    in
    
    Css.batch styles

deckStyle : Style
deckStyle = 
    let
        color = (hex "#0c5a99")
        backgroundColorStyle = Css.backgroundColor color
        boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
        styles = [ backgroundColorStyle, boxShadowStyle, cardStyle ]
    in
    Css.batch styles

paddingStyle : Style
paddingStyle = 
    Css.batch [ Css.padding (px 20) ]

centerText: Style
centerText = 
    textAlign center

-- Stars 
filledStar: StyledHtml.Html msg
filledStar = 
    let
        starString = String.fromChar (Char.fromCode 0x2605)
        styles = [ Css.fontSize (pct 100), color (rgb 255 255 255) ]
    in
    StyledHtml.span
        [ css styles]
        [ StyledHtml.text starString]
    
unfilledStar: StyledHtml.Html msg
unfilledStar = 
    let 
        starString = String.fromChar (Char.fromCode 0x2606)
        styles = [ Css.fontSize (pct 100), color (rgb 255 255 255) ]
    in
    StyledHtml.span
        [ css styles]
        [ StyledHtml.text starString]

flexStyle: Style
flexStyle =
    Css.display Css.block
    -- Css.display Css.table
