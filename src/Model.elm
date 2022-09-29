module Model exposing (..)
import Club exposing (Club)
import Player exposing (PlayerOrPlaceholder, playerPlaceHolderName)
import Html.Styled as StyledHtml exposing (Attribute, div, h2, h4, text, toUnstyled, span)
import Html.Styled.Attributes exposing (attribute, css, class)
import Html
import Css
import List exposing (map)
import Msg exposing (Msg)
import Player exposing (PlayerOrPlaceholder(..))
import Array exposing (Array)
import Init
import Random.List

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Msg.Increment ->
      ( model 
      , Cmd.none
      )

    Msg.Decrement ->
      ( model 
      , Cmd.none
      )

    Msg.Select (player) ->
      ( model 
      , Cmd.none
      )
    
    Msg.Swap player ->
      ( { model | swapPlayers = player :: model.swapPlayers } |> swapPlayersWithinClub
      , Cmd.none
      )

    Msg.Draft (player) ->
      ( model 
      , Cmd.none
      )



-- VIEW
view : Model -> Html.Html Msg
view model =
    -- model |> squadView |>  toUnstyled
    model.club |> Club.clubFolderHtml |> toUnstyled

    

squadView : Model -> StyledHtml.Html msg
squadView model = 
  let
      club = model.club
      squad = Club.squad club
  in
  

    StyledHtml.div
    [ css [  ] ]
    <| [ squadToHtml squad ]



-- MODEL
type alias Model = 
    { club : Club 
    , swapPlayers : List PlayerOrPlaceholder
    , playerDeck : List PlayerOrPlaceholder
    }


 
init : () -> (Model, Cmd Msg)
init _ =
  let
    reserves = Array.fromList Init.arsenalReserves
    starters = Array.fromList Init.arsenalStarters
      -- Array.initialize 20 (\n -> playerPlaceHolderName "starter" n)
    club =  { balance = 0
            , stadium_level = Club.I
            , scouting_level = Club.I
            , training_level = Club.I
            , club_level = Club.NewlyPromoted
            , club_position = Club.Fifth
            , reserves = reserves
            , starters = starters
            }
    model =   { club = club, swapPlayers = [], playerDeck = Init.playerDeck}
  in
  ( model
  , Cmd.none
  )


swapPlayersWithinClub: Model -> Model
swapPlayersWithinClub model =
  case List.length model.swapPlayers of
    2 -> 
      -- here we swap players
      model
    _ -> model



squadToHtml: List PlayerOrPlaceholder -> StyledHtml.Html msg
squadToHtml players = 
  let
    attributes = [ css 
                    [ Css.display Css.inlineFlex
                    , Css.flexFlow1 Css.wrap
                    ]
                  , class "squad"
                  ]

    squadHtml = map Player.playerToHtml players
  in
  StyledHtml.div attributes squadHtml

