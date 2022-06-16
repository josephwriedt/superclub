module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Main

simGame : Test
simGame = 
    describe "Simulate Game"
        [ test "Losing Rolls" <| 
            \() -> Main.simGame 1 1 
                |>  Expect.equal Main.Loss
        
        , test "Winning Rolls" <|
            \() -> Main.simGame 4 5
                |> Expect.equal Main.Win

        , test "Tie Rolls" <| 
            \() -> Main.simGame 3 4
                |> Expect.equal Main.Draw
        ]

hasChemistry : Test
hasChemistry = 
    let
        right = Main.Player "" Main.DEF Main.Right 0 0 0 0
        left = Main.Player "" Main.GK Main.Left 0 0 0 0
        both = Main.Player "" Main.ATT Main.Both 0 0 0 0
        none = Main.Player "" Main.ATT Main.None 0 0 0 0
    in 
    describe "Test Chemistry"
        [ test "No Chemistry" <|
            \() -> Main.hasChemistry none none 
                |> Expect.equal False
        , test "Opposite Chemistry" <|
            \() -> Main.hasChemistry left right
                |> Expect.equal False
        , test "Right with Left" <|
            \() -> Main.hasChemistry right left 
                |> Expect.equal True
        , test "Right with Both" <|
            \() -> Main.hasChemistry right both
                |> Expect.equal True
        , test "Both with Left" <|
            \() -> Main.hasChemistry both left
                |> Expect.equal True
        , test "Both with Both" <|
            \() -> Main.hasChemistry both both
                |> Expect.equal True
        
        ]