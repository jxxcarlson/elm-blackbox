module BlackBox exposing (transform)


transform : String -> String
transform input =
    "Characters: " ++ String.fromInt (String.length (String.trim input))
