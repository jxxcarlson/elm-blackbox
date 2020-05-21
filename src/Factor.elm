module Factor exposing (factor, helpText, transform)


transform : String -> String
transform input =
    case String.toInt (String.trim input) of
        Nothing ->
            "Bad input (" ++ input ++ ")"

        Just n ->
            factor n |> showIntList


showIntList : List Int -> String
showIntList list =
    list
        |> List.map String.fromInt
        |> String.join ", "


factor : Int -> List Int
factor n =
    factorHelper 2 n []


factorHelper : Int -> Int -> List Int -> List Int
factorHelper divisor n factors =
    case divisor * divisor > n of
        True ->
            n :: factors

        False ->
            case modBy divisor n == 0 of
                True ->
                    factorHelper divisor (n // divisor) (divisor :: factors)

                False ->
                    factorHelper (divisor + 1) n factors


helpText =
    """This program factors smallish numbers into primes, e.g:

    > 1234567
    9721, 127

    > 233
    233
"""
