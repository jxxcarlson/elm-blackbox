module Statistics exposing (helpText, transform)

import List.Extra
import Statistics.Function as SF
import Statistics.Parse as SP


transform : String -> String
transform input =
    case String.left 1 input == ":" of
        True ->
            processCommand input

        False ->
            statistics input


processCommand : String -> String
processCommand input =
    input


statistics : String -> String
statistics input =
    case SP.parseNumbers (String.replace "," " " input) of
        Nothing ->
            "Error: numbers must be separated by spaces and newlines"

        Just data ->
            let
                m =
                    SF.mean data |> roundTo 3 |> String.fromFloat

                s =
                    SF.stdev data |> roundTo 3 |> String.fromFloat

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
                ++ " data points\nmean = "
                ++ m
                ++ ", stdev = "
                ++ s
                ++ "\nmax = "
                ++ max_
                ++ ", min = "
                ++ min_
                ++ "\n"


helpText =
    """Commands:

    :help             help
    :get FILE         load FILE into memory, apply BlackBox.transform to it
    :show             show contents of memory
    :head             first five lines of memory
    :tail             last five lines of memory
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
