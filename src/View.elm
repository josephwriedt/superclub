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
                              PlayerDisplay.playerToHtml player 
                            Nothing -> div [] []
  in
  
    toUnstyled <|
      div []
          [ deckView
          , randomPlayerHtml
          , inspectPlayer model
          , Club.clubFolderHtml model.club
          ]


inspectPlayer : Model -> StyledHtml.Html Msg
inspectPlayer model = 
  StyledHtml.node "inspect-player" 
    -- [ css [ Css.display Css.inlineBlock, Css.flexFlow1 Css.wrap ] ] 
    []
    [ PlayerDisplay.playerToHtml model.inspectedPlayer
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
      squad = Club.squad club
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

    squadHtml = List.map PlayerDisplay.playerToHtml players
  in
  StyledHtml.div attributes squadHtml
