module Gamestyle exposing (..)
import Css exposing (..)
import Html exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Html.Styled as StyledHtml 

-- Element Size Styles
marginStyle : Style
marginStyle =
    Css.batch [ margin (px 20) ]

paddingStyle : Style 
paddingStyle =
    Css.batch [ padding (px 10) ]

borderStyle : Style
borderStyle = 
    Css.batch [ border (px 10) ]


-- Reminder to apply this to the children elements that want to be in a row
flexStyle : Style
flexStyle =
    display Css.inline

displayStyle : Style
displayStyle =
    display inlineFlex

-- Player Card Styles
cardDimensions : Style
cardDimensions = 
    Css.batch [ height (px 170)
              , width (px 120)
              ]

cardOutlineStyle : Style
cardOutlineStyle = 
    Css.outlineStyle solid

cardBorderRadiusStyle : Style
cardBorderRadiusStyle =
    borderRadius (px 10)

cardStyle : Style
cardStyle =
    Css.batch [ marginStyle
              , borderStyle
              , paddingStyle
              , cardDimensions
              , cardOutlineStyle
              , cardBorderRadiusStyle
              ]


-- cardStyle : Style
-- cardStyle = 
--     Css.batch 
--         [ Css.border (px 10)
--         , Css.padding (px 50)
--         , Css.outlineStyle Css.solid
--         , borderRadius (px 10)
--         , Css.padding (pct 5)
--         , cardDimensions
--         ]

-- Folder Style
folderMarginStyle : Style
folderMarginStyle = 
    margin (pct 2.5)



folderStyle : Style
folderStyle = 
    Css.batch [ borderStyle
              , cardOutlineStyle
              , cardBorderRadiusStyle
              , marginStyle
              ]

playerPlaceholderStyle : Color -> Style
playerPlaceholderStyle color =
    Css.batch [ cardStyle
              , backgroundColor color
              , boxShadow4 (px 10) (px 10) (px 5) color
              ]


-- playerPlaceholderStyle : Style
-- playerPlaceholderStyle = 
--     let
--         color = (hex "#e0e0e0")
--         backgroundColorStyle = Css.backgroundColor color
--         boxShadowStyle = Css.boxShadow4 (px 10) (px 10) (px 5) color
--         styles = [ backgroundColorStyle, boxShadowStyle, cardStyle ]
--     in
--     Css.batch styles

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
        cStyle = Css.batch [ Css.border (px 10)
                            , Css.padding (px 50)
                            , Css.outlineStyle Css.solid
                            , borderRadius (px 10)
                            -- , Css.padding (px 10) 
                            , cardDimensions
                            ]
        styles = [ backgroundColorStyle, boxShadowStyle, cStyle ]
    in
    Css.batch styles

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

