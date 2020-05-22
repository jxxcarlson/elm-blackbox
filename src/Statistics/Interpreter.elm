module Statistics.Interpreter exposing (execute, executeCmd, sliceList)

import List.Extra
import Statistics.Commands exposing (Command(..), Format(..))


execute : List Command -> List String -> List String
execute commandList input =
    let
        folder =
            \cmd list -> executeCmd cmd list
    in
    List.foldl folder input commandList


executeCmd : Command -> List String -> List String
executeCmd command list =
    case command of
        Ignore n ->
            List.drop n list

        Rows a b ->
            sliceList (a - 1) (b - 1) list

        Column k format ->
            case format of
                Csv ->
                    list
                        |> List.map (String.split ",")
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



--> List.drop a
--|> List.drop (a - 1)
