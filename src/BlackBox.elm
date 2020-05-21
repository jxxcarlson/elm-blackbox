module BlackBox exposing (helpText, transform)


transform : String -> String
transform input_ =
    let
        input =
            String.trim input_
    in
    [ lineCount input, wordCount input, charCount input ]
        |> List.map String.fromInt
        |> String.join ", "


lineCount : String -> Int
lineCount str =
    str |> String.lines |> List.length


wordCount : String -> Int
wordCount str =
    str |> String.words |> List.length


charCount : String -> Int
charCount str =
    str |> String.length



-- HELP TEXT


helpText =
    """Commands:

    :help             help
    :get FILE         load FILE into memory, apply BlackBox.transform to it
    :show             show contents of memory
    :app              apply BlackBox.transform to the contents of memory

    STRING            apply BlackBox.transform to STRING

Example using the default BlackBox:

    > :help                 # show help screen

    > foo bar               # apply transform to "foo bar" -- report lines, words, chars
    1, 2, 7

    > :get src/repl.js      # load file into memory and apply transform to it
    42, 97, 863

    > :app                  # apply transform to contents of memory
    42, 97, 863
"""
