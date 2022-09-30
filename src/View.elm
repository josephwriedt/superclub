module View exposing (..)
import Model exposing (Model)
import Club
import Player exposing (PlayerOrPlaceholder)
import GameStyle
import PlayerDisplay
-- Display Packages
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css
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
          [ deckView model, randomPlayerHtml, Club.clubFolderHtml model.club]
    -- model |> squadView |>  toUnstyled
    -- model.club |> Club.clubFolderHtml |> toUnstyled


deckView : Model -> StyledHtml.Html Msg 
deckView model =
    div [ class "player-decks" ]
        [ deck "Europe", deck "Asia", deck "South America", deck "North America", deck "Australia" ]

deck : String -> StyledHtml.Html Msg 
deck region = 
    let
        className = region ++ "-deck" 
        textStyle = [ Css.color (Css.rgb 255 255 255)
                    , GameStyle.centerText
                    , Css.textAlign Css.textTop
                    ]
    in
    
    div [ class className
        , onClick Msg.RandomDeckPlayer
        -- , css [ GameStyle.deckStyle ]
        , css [ Css.display Css.inlineFlex, Css.flexFlow1 Css.wrap, GameStyle.deckStyle ]
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
                    [ Css.display Css.inlineFlex
                    , Css.flexFlow1 Css.wrap
                    ]
                  , class "squad"
                  ]

    squadHtml = map PlayerDisplay.playerToHtml players
  in
  StyledHtml.div attributes squadHtml

