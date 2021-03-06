module Test.Generated.Main exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = ConsoleReport UseColor
        , seed = 266811192468477
        , processes = 8
        , globs =
            []
        , paths =
            [ "/Users/klausklasens/Documents/GitHub/superclub/tests/Example.elm"
            ]
        }
        [ ( "Example"
          , [ Test.Runner.Node.check Example.simGame
            , Test.Runner.Node.check Example.hasChemistry
            ]
          )
        ]