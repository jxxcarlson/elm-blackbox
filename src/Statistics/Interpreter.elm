module Statistics.Interpreter exposing (execute, executeCmd, sliceList)

import Csv
import List.Extra
import Statistics.Commands exposing (Command(..), Format(..))
import Statistics.Function as SF
import Statistics.Utility as Utility


execute : List Command -> List String -> String
execute commandList input =
    case List.head commandList of
        Nothing ->
            "Error: no valid commands to process"

        Just command ->
            case command of
                Regression ->
                    regression (List.drop 1 commandList) input

                _ ->
                    univariate commandList input


regression : List Command -> List String -> String
regression commandList input =
    let
        cmd1_ =
            List.Extra.getAt 0 commandList

        cmd2_ =
            List.Extra.getAt 1 commandList

        args =
            List.drop 2 commandList
    in
    case ( cmd1_, cmd2_ ) of
        ( Nothing, _ ) ->
            "Error: missing command 1"

        ( _, Nothing ) ->
            "Error: missing command 2"

        ( Just cmd1, Just cmd2 ) ->
            let
                xs =
                    prepareData (cmd1 :: args) input

                ys =
                    prepareData (cmd2 :: args) input

                r =
                    SF.regressionData xs ys
            in
            "\nm = " ++ show r.m ++ ", b = " ++ show r.b ++ ", r2 = " ++ show r.r2 ++ "\n"


show : Float -> String
show x =
    x |> Utility.roundTo 3 |> String.fromFloat


univariate : List Command -> List String -> String
univariate commandList input =
    prepareData commandList input
        |> SF.statistics


prepareData : List Command -> List String -> List Float
prepareData commandList input =
    (let
        folder =
            \cmd list -> executeCmd cmd list
     in
     List.foldl folder input commandList
    )
        |> List.map (String.toFloat >> Maybe.withDefault 0)


executeCmd : Command -> List String -> List String
executeCmd command list =
    case command of
        Regression ->
            list

        Ignore n ->
            List.drop n list

        Rows a b ->
            sliceList (a - 1) (b - 1) list

        Column k format ->
            case format of
                Csv ->
                    let
                        data =
                            Csv.parseWith "," (String.join "\n" list)
                    in
                    data.records
                        |> List.map (getItem (k - 1) >> String.trim)

                Space ->
                    list
                        |> List.map
                            (String.split " "
                                >> List.filter (\x -> x /= "")
                            )
                        |> List.map (getItem (k - 1))


getItem : Int -> List String -> String
getItem k list =
    List.Extra.getAt k list
        |> Maybe.withDefault "X"


sliceList : Int -> Int -> List a -> List a
sliceList a b list =
    list
        |> List.take (b + 1)
        |> List.drop a
