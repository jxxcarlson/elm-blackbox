module Statistics.Function exposing (RegressionData, mean, regressionData, statistics, stdev)

import List.Extra
import Statistics.Utility as Utility


mean : List Float -> Float
mean numbers =
    let
        n =
            List.length numbers |> toFloat
    in
    List.sum numbers / n


variance : List Float -> Float
variance numbers =
    numbers
        |> center
        |> sumOfSquares


covariance : List Float -> List Float -> Float
covariance xs ys =
    List.map2 (*) (center xs) (center ys)
        |> List.sum


type alias RegressionData =
    { m : Float, b : Float, sse : Float, ssto : Float, r2 : Float }


regressionData : List Float -> List Float -> RegressionData
regressionData xs ys =
    let
        m =
            covariance xs ys / variance xs

        xbar =
            mean xs

        ybar =
            mean ys

        b =
            ybar - m * xbar

        ys_ =
            List.map (\x -> m * x + b) xs

        ys_ybar =
            List.map (\y -> y - ybar) ys_

        sse =
            List.map2 (\x y -> (x - y) * (x - y)) ys ys_
                |> List.sum

        ssto =
            sumOfSquares ys_ybar

        r2 =
            1 - sse / ssto
    in
    { m = m, b = b, sse = sse, ssto = ssto, r2 = r2 }


stdev : List Float -> Float
stdev numbers =
    let
        n =
            List.length numbers |> toFloat

        averageVariance =
            variance numbers / (n - 1)
    in
    sqrt averageVariance


center : List Float -> List Float
center numbers =
    let
        m =
            mean numbers
    in
    List.map (\x -> x - m) numbers


sumOfSquares : List Float -> Float
sumOfSquares numbers =
    numbers
        |> List.map (\x -> x * x)
        |> List.sum


statistics : List Float -> String
statistics data =
    let
        m =
            mean data |> Utility.roundTo 3 |> String.fromFloat

        s =
            stdev data |> Utility.roundTo 3 |> String.fromFloat

        max_ =
            List.Extra.maximumBy identity data
                |> Maybe.withDefault 0
                |> String.fromFloat

        min_ =
            List.Extra.minimumBy identity data
                |> Maybe.withDefault 0
                |> String.fromFloat

        n =
            List.length data |> String.fromInt
    in
    "\n"
        ++ n
        ++ " items (lines/numbers)\nmean = "
        ++ m
        ++ ", stdev = "
        ++ s
        ++ "\nmax = "
        ++ max_
        ++ ", min = "
        ++ min_
        ++ "\n"


roundTo : Int -> Float -> Float
roundTo n x =
    let
        factor =
            10.0 ^ toFloat n
    in
    factor
        * x
        |> round
        |> toFloat
        |> (\u -> u / factor)
