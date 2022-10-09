module Init exposing (..)
import Random
import Player exposing (PlayerOrPlaceholder(..), playerPlaceHolderName)
import List

arsenal: List PlayerOrPlaceholder
arsenal = 
    [ Player { name = "Jesus", position = Player.ATT, chemistry = Player.NoChemistry, ability = 4, potential = 5, market_value = 60, scout_value = 40 }
    , Player { name = "Martinelli", position = Player.ATT, chemistry = Player.Right, ability = 3, potential = 5, market_value = 40, scout_value = 20 }
    , Player { name = "Saka", position = Player.ATT, chemistry = Player.Left, ability = 3, potential = 6, market_value = 25, scout_value = 12 }
    , playerPlaceHolderName "starter" 1
    , playerPlaceHolderName "starter" 2
    ]

arsenalReserves: List PlayerOrPlaceholder
arsenalReserves = 
    [ Player { name = "Nketiah", position = Player.ATT, chemistry = Player.Left, ability = 2, potential = 5, market_value = 25, scout_value = 15 } 
    , Player { name = "Turner", position = Player.GK, chemistry = Player.NoChemistry, ability = 2, potential = 2, market_value = 15, scout_value = 10 }
    , Player { name = "Cedric", position = Player.DEF, chemistry = Player.NoChemistry, ability = 2, potential = 3, market_value = 10, scout_value = 5 }
    , Player { name = "Erik", position = Player.DEF, chemistry = Player.Left, ability = 6, potential = 6, market_value = 100, scout_value = 5 }
    , Player { name = "Caroline", position = Player.GK, chemistry = Player.NoChemistry, ability = 6, potential = 6, market_value = 10, scout_value = 5 }
    , PlayerPlaceholder "6"
    , PlayerPlaceholder "7"
    , PlayerPlaceholder "8"
    , PlayerPlaceholder "9"
    , PlayerPlaceholder "10"
    , PlayerPlaceholder "11"
    , PlayerPlaceholder "12"
    , PlayerPlaceholder "13"
    , PlayerPlaceholder "14"
    , PlayerPlaceholder "15"
    ]

arsenalAttackers: List PlayerOrPlaceholder
arsenalAttackers = 
    [ Player { name = "Jesus", position = Player.ATT, chemistry = Player.NoChemistry, ability = 4, potential = 5, market_value = 60, scout_value = 40 }
    , Player { name = "Martinelli", position = Player.ATT, chemistry = Player.Right, ability = 3, potential = 5, market_value = 40, scout_value = 20 }
    , Player { name = "Saka", position = Player.ATT, chemistry = Player.Left, ability = 3, potential = 6, market_value = 25, scout_value = 12 }
    , playerPlaceHolderName "starter-attacker" 1
    , playerPlaceHolderName "starter-attacker" 2
    ]

arsenalMidfielders: List PlayerOrPlaceholder
arsenalMidfielders = 
    [ Player { name = "Odegaard", position = Player.MID, chemistry = Player.NoChemistry, ability = 3, potential = 6, market_value = 30, scout_value = 5 }
    , Player { name = "Xhaka", position = Player.MID, chemistry = Player.Right, ability = 3, potential = 3, market_value = 20, scout_value = 10 }
    , Player { name = "Thomas", position = Player.MID, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 35, scout_value = 24 }
    , playerPlaceHolderName "stater-midfielder" 1
    , playerPlaceHolderName "stater-midfielder" 2
    ]

arsenalDefenders: List PlayerOrPlaceholder
arsenalDefenders = 
    [ Player { name = "Ramsdale", position = Player.GK, chemistry = Player.NoChemistry, ability = 3, potential = 5, market_value = 30, scout_value = 15 }
    , Player { name = "Tierney", position = Player.DEF, chemistry = Player.Right, ability = 3, potential = 4, market_value = 30, scout_value = 15 }
    , Player { name = "Saliba", position = Player.DEF, chemistry = Player.NoChemistry, ability = 3, potential = 6, market_value = 45, scout_value = 27 }
    , Player { name = "White", position = Player.DEF, chemistry = Player.Right, ability = 3, potential = 4, market_value = 10, scout_value = 5 }
    , Player { name = "Tomiyasu", position = Player.DEF, chemistry = Player.NoChemistry, ability = 3, potential = 3, market_value = 20, scout_value = 10 }
    , playerPlaceHolderName "starter-defender" 1
    ]

arsenalStarters: List PlayerOrPlaceholder
arsenalStarters =
    arsenalAttackers ++ arsenalMidfielders ++ arsenalDefenders

playerDeck: List PlayerOrPlaceholder
playerDeck = 
    [ Player { name = "Jesus", position = Player.ATT, chemistry = Player.NoChemistry, ability = 4, potential = 5, market_value = 60, scout_value = 40 }
    , Player { name = "Martinelli", position = Player.ATT, chemistry = Player.Right, ability = 3, potential = 5, market_value = 40, scout_value = 20 }
    , Player { name = "Saka", position = Player.ATT, chemistry = Player.Left, ability = 3, potential = 6, market_value = 25, scout_value = 12 }
    , Player { name = "Odegaard", position = Player.MID, chemistry = Player.NoChemistry, ability = 3, potential = 6, market_value = 30, scout_value = 5 }
    , Player { name = "Xhaka", position = Player.MID, chemistry = Player.Right, ability = 3, potential = 3, market_value = 20, scout_value = 10 }
    , Player { name = "Thomas", position = Player.MID, chemistry = Player.NoChemistry, ability = 5, potential = 5, market_value = 35, scout_value = 24 }
    , Player { name = "Tierney", position = Player.DEF, chemistry = Player.Right, ability = 3, potential = 4, market_value = 30, scout_value = 15 }
    , Player { name = "Saliba", position = Player.DEF, chemistry = Player.NoChemistry, ability = 3, potential = 6, market_value = 45, scout_value = 27 }
    , Player { name = "White", position = Player.DEF, chemistry = Player.Right, ability = 3, potential = 4, market_value = 10, scout_value = 5 }
    , Player { name = "Tomiyasu", position = Player.DEF, chemistry = Player.NoChemistry, ability = 3, potential = 3, market_value = 20, scout_value = 10 }
    , Player { name = "Nketiah", position = Player.ATT, chemistry = Player.Left, ability = 2, potential = 5, market_value = 25, scout_value = 15 } 
    , Player { name = "Turner", position = Player.GK, chemistry = Player.NoChemistry, ability = 2, potential = 2, market_value = 15, scout_value = 10 }
    , Player { name = "Cedric", position = Player.DEF, chemistry = Player.NoChemistry, ability = 2, potential = 3, market_value = 10, scout_value = 5 }
    , Player { name = "Erik", position = Player.DEF, chemistry = Player.Left, ability = 6, potential = 6, market_value = 100, scout_value = 5 }
    , Player { name = "Caroline", position = Player.GK, chemistry = Player.NoChemistry, ability = 6, potential = 6, market_value = 10, scout_value = 5 }                
    ]