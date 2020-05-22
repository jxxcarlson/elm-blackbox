module Statistics exposing (helpText, transform)

import List.Extra
import Statistics.Commands as Commands
import Statistics.Function as SF
import Statistics.Interpreter as Interpreter
import Statistics.ParseData as ParseData


transform : String -> String
transform input =
    case String.left 1 input == ":" of
        True ->
            processCommand input

        False ->
            statisticsOfString input


processCommand : String -> String
processCommand input =
    let
        lines =
            String.lines input

        command =
            List.head lines
                |> Maybe.withDefault ""
                |> String.dropLeft 1

        data =
            lines
                |> List.drop 1
    in
    applyCommand command data


applyCommand : String -> List String -> String
applyCommand command data =
    case Commands.parse command of
        Nothing ->
            "Error parsing commands"

        Just commands ->
            Interpreter.execute commands data
                |> List.map (String.toFloat >> Maybe.withDefault 0)
                |> statistics


statisticsOfString : String -> String
statisticsOfString input =
    case ParseData.parseNumbers (String.replace "," " " input) of
        Nothing ->
            "Error: numbers must be separated by spaces and newlines"

        Just [] ->
            "\n  No data processed. Maybe the file format is csv or some other format (space or tab-spaceDelimited)."
                ++ "\n\n  Try :head to see what is in the file."
                ++ "\n\n  You may need to say something like ':get FILENAME column=5:csv' or ':app column=5:csv'\n"

        Just data ->
            statistics data


statistics : List Float -> String
statistics data =
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

    :help             Help
    :get FILE         Load FILE into memory, apply Statistics.transform to it
    :show             Show contents of memory
    :head             First five lines of memory
    :tail             Last five lines of memory
    :app              Apply Statistics.transform to the contents of memory

    STRING            Apply Statistics.transform to STRING

Commands with arguments:

    :get w.csv column=5:csv         Load w.csv and run statistics on column 5
    :app column=5:csv rows=:2:32    Same, but use only rows 2 through 32
    :get x.txt column=2:space       Space-delimited file
    :get y.txt column=2:tab         Tab-delimited file (not yet implemented)

Examples:

    > 1 2 3
    3 data points, mean = 2, stdev = 1

    > :get w.csv column=5:csv

    362 data points
    mean = 16.393, stdev = 10.681
    max = 35.6, min = -11.1

    > :app column=6:csv

    362 data points
    mean = 6.066, stdev = 9.695
    max = 25, min = -18.3
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
