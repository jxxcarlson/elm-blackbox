module Statistics exposing (getArg, helpText, transform)

import Parser exposing (Parser)
import Parser.Extras


transform : String -> String
transform input =
    case String.left 1 input == ":" of
        True ->
            processCommand input

        False ->
            statistics input


processCommand : String -> String
processCommand command =
    let
        lines =
            String.lines command

        commandString =
            List.head lines |> Maybe.withDefault ":noOp"

        args_ =
            String.words commandString

        data =
            List.drop 1 lines
    in
    "Command = " ++ command


getArg : Int -> List String -> String
getArg n args =
    args
        |> List.drop n
        |> List.head
        |> Maybe.withDefault ""


statistics : String -> String
statistics input_ =
    let
        input =
            String.replace "\n" " " input_
    in
    case parseNumbers input of
        Nothing ->
            "Error: numbers must be separated by spaces and newlines"

        Just data ->
            let
                m =
                    mean data |> roundTo 3 |> String.fromFloat

                s =
                    stdev data |> roundTo 3 |> String.fromFloat

                n =
                    List.length data |> String.fromInt
            in
            n ++ " data points, mean = " ++ m ++ ", stdev = " ++ s


helpText =
    """Commands:

    :help             help
    :get FILE         load FILE into memory, apply BlackBox.transform to it
    :show             show contents of memory
    :app              apply BlackBox.transform to the contents of memory

    STRING            apply BlackBox.transform to STRING

Example using the default BlackBox:

    > 1 2 3
    3 data points, mean = 2, stdev = 1

    > :get src/repl.js      # load file into memory and apply transform to it
    42, 97, 863

    > :app                  # apply transform to contents of memory
    42, 97, 863
"""



-- HELPERS


parseNumbers : String -> Maybe (List Float)
parseNumbers str =
    case Parser.run numbersParser str of
        Ok numbers ->
            Just numbers

        Err _ ->
            Nothing


numbersParser : Parser (List Float)
numbersParser =
    Parser.Extras.many Parser.float


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
