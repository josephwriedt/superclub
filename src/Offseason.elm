module Offseason exposing (..)
import Club exposing (Club, FacilityLevel, ClubLevel)
import Player exposing (Player)
import Main exposing (Model)

-- Finance Step
finance: Club -> Club
finance a = 
    let
        newBalance = List.sum [a.balance, stadiumIncome a, negate <| wages a, clubPlacement a]
    in
    {a | balance = newBalance}
    


stadiumIncome: Club -> Int
stadiumIncome a = 
    (*) (clubPlacementMultiplier a.club_level) (facilityIncomeBonus a.stadium_level)
        |> Basics.round


facilityIncomeBonus: Club.FacilityLevel -> Float
facilityIncomeBonus a =
    let
        multiplier = 1.5
    in
    case a of 
        Club.I -> multiplier
        Club.II -> multiplier ^ 2
        Club.III -> multiplier ^ 3
        Club.IV -> multiplier ^ 4


clubPlacementMultiplier: ClubLevel -> Float
clubPlacementMultiplier club_level =
    case club_level of
        Club.NewlyPromoted -> 20
        Club.Established -> 30
        Club.MidTable -> 40
        Club.TitleContenders -> 50

wages: Club -> Int
wages a = 
    a.squad |> Player.sumAbility
clubPlacement: Club -> Int
clubPlacement a =
    case a.club_position of
        Club.First -> 100
        Club.Second -> 90
        Club.Third -> 80
        Club.Fourth -> 70
        Club.Fifth -> 60
        Club.Sixth -> 50


-- -- Training Step
-- training: Club -> Club
-- training a =
--     case a.training_level of
--         Club.I ->
--             -- upgrade one player
--         Club.II
--             -- upgrade two players up to two stars
--         Club.III
--             -- upgrade three players up to three stars
--         Club.IV
--             -- upgrade 4 players up to 4 stars with one player guaranteed one star increase
--     -- Select player and improve
--     {a | squad = "placeholder"}

increaseAbility: Player -> Int -> Int -> Player
increaseAbility player max_increase roll =
    let
        increase = (roll - player.ability) |> clamp 0 max_increase
        new_ability = increase + player.ability
    in
    if new_ability < player.potential then
        {player | ability = new_ability}
    else 
        {player | ability = player.potential}

-- Scouting Step
-- scouting: Club -> Model -> 

-- Investment Step

-- Deadline Day

