module BlackBox exposing (transform)


transform : String -> String
transform input_ =
    let
        input =
            String.trim input_
    in
    "Characters: " ++ String.fromInt (String.length input) ++ " [" ++ input ++ "]"
