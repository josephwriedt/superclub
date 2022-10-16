module View exposing (..)
import Model exposing (Model)
import Club
import Player exposing (PlayerOrPlaceholder)
import Gamestyle
import PlayerDisplay
-- Display Packages
import Html.Styled as StyledHtml exposing (..)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css exposing (..)
import Svg.Styled as Svg
import Svg.Styled.Attributes as Svg
-- Helper Packages
import List exposing (map)
import Msg exposing (Msg)
import Html.Styled.Events exposing (onClick)

-- VIEW
view : Model -> Html.Html Msg
view model =
  let
      randomPlayerHtml = case model.randomPlayer of
                            Just player ->
                              PlayerDisplay.playerToHtmlDefault player 
                            Nothing -> div [] []
  in
  
    toUnstyled <|
      div []
          [ Club.clubFolderHtml model.club
          , div [] [ leftFacingStar, rightFacingStar ] 
          ]
          -- [ deckView
          -- , randomPlayerHtml
          -- , Club.clubFolderHtml model.club
          -- ]

leftFacingStar : Svg.Svg Msg
leftFacingStar =
  Svg.svg
    [ Svg.height "200", Svg.width "500" ]
    [ Svg.polygon
      [ Svg.points "100,10 160,198 100,150 100,78 190,78 100,150" ]
      []
    ]
    

rightFacingStar : Svg.Svg Msg
rightFacingStar =
  Svg.svg 
    [ Svg.height "200", Svg.width "500" ]
    [ Svg.polygon
      [ Svg.points "100,10 40,198 100,150 100,78 10,78 100,150", Svg.fill "black" ]
      -- [ Svg.points "100,10 40,198 190,78 10,78 160,198", Svg.fill "black" ]
      []
    ]
  


inspectPlayer : Model -> StyledHtml.Html Msg
inspectPlayer model = 
  StyledHtml.node "inspect-player"  
    [ css [ Css.display Css.block ] ]
    [ PlayerDisplay.playerToHtmlDefault model.inspectedPlayer
    , inspectPlayerButtons model
    ]

inspectPlayerButtons : Model -> StyledHtml.Html Msg
inspectPlayerButtons model = 
  let
      buttonStyle = css [ display block, margin (px 10) ]
  in
  div  
    [  ]
    [ button [ buttonStyle ] [ text "Aquire" ]
    , button [ buttonStyle ] [ text "Sell" ]
    , button [ buttonStyle ] [ text "Train" ]
    ]

deckView : StyledHtml.Html Msg 
deckView =
    div [ class "player-decks" ]
        [ deck "Europe", deck "Asia", deck "South America", deck "Australia", deck "North" ]

deck : String -> StyledHtml.Html Msg 
deck region = 
    let
        className = region ++ "-deck" 
        marginStyle = Css.margin Css.auto
        textStyle = [ Css.color (Css.rgb 255 255 255)
                    , Gamestyle.centerText
                    , marginStyle
                    ]
    in
    
    div [ class className
        , onClick Msg.RandomDeckPlayer
        -- , css [ Gamestyle.deckStyle ]
        , css [ Css.display Css.inlineBlock, Css.flexFlow1 Css.wrap, Gamestyle.deckStyle, Css.margin (Css.px 20) ]
        ]
        [ StyledHtml.h3 [ css textStyle ] [ StyledHtml.text region ]
        ]

squadView : Model -> StyledHtml.Html Msg
squadView model = 
  let
      club = model.club
      squad = Club.clubSquad club
  in
  

    StyledHtml.div
    [ css [  ] ]
    <| [ squadToHtml squad ]

squadToHtml: List PlayerOrPlaceholder -> StyledHtml.Html Msg
squadToHtml players = 
  let
    attributes = [ css 
                    [ Gamestyle.displayStyle
                    , Css.flexFlow1 Css.wrap
                    ]
                  , class "squad"
                  ]

    squadHtml = List.map PlayerDisplay.playerToHtmlDefault players
  in
  StyledHtml.div attributes squadHtml
