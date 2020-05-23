module Statistics exposing (helpText, identify, transform)

import List.Extra
import Statistics.Commands as Commands
import Statistics.Function as SF
import Statistics.Interpreter as Interpreter
import Statistics.ParseData as ParseData


identify =
    "Black box = Statistics"


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
            SF.statistics data


helpText =
    """Commands:

    :help             Help
    :get FILE         Load FILE into memory, compute mean, standard deviation, etc.
    :show             Show contents of memory
    :head             First five lines of memory
    :tail             Last five lines of memory
    :mem              Compute mean, standard deviation, etc. for the contents of memory

    STRING            Compute mean, standard deviation, etc. of the data in STRING

Commands with arguments:

    :get w.csv column=5:csv         Load w.csv and run statistics on column 5
    :app column=5:csv rows=:2:32    Same, but use only rows 2 through 32
    :get x.txt column=2:space       Space-delimited file
    :get y.txt column=2:tab         Tab-delimited file (not yet implemented)

Examples:

    > 1 2 3
    3 data points, mean = 2, stdev = 1

    > :get data1.txt

    362 data points
    mean = 16.393, stdev = 10.681
    max = 35.6, min = -11.1

    > :head
    # Maximum daily temperatures for New York City, 2019
    # Source: https://www.climate.gov/maps-data/dataset/past-weather-zip-code-data-table
    11.7
    12.8
    3.3

    > :get w.csv column=5:csv

    362 data points
    mean = 16.393, stdev = 10.681
    max = 35.6, min = -11.1

    > :app column=6:csv

    362 data points
    mean = 6.066, stdev = 9.695
    max = 25, min = -18.3

    > :get w.csv regression column=5:csv column=6:csv

    m = 0.853, b = -7.915, r2 = 0.867

"""



-- HELPERS
