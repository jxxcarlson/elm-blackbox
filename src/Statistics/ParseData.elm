module Statistics.ParseData exposing (parseNumbers)

import Parser exposing ((|.), (|=), Parser)
import Parser.Extras


parseNumbers : String -> Maybe (List Float)
parseNumbers str =
    case Parser.run numbersParser str of
        Ok numbers ->
            Just numbers

        Err _ ->
            Nothing


numbersParser : Parser (List Float)
numbersParser =
    Parser.Extras.many signedNumber


signedNumber : Parser Float
signedNumber =
    Parser.oneOf [ negativeNumber, Parser.float ]


negativeNumber : Parser Float
negativeNumber =
    (Parser.succeed identity
        |. Parser.symbol "-"
        |= Parser.float
    )
        |> Parser.map (\x -> -x)


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


stdev : List Float -> Float
stdev numbers =
    let
        n =
            List.length numbers |> toFloat

        averageVariance =
            variance numbers / (n - 1)
    in
    sqrt averageVariance


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
