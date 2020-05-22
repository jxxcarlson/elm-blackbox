module Statistics.ParseData exposing (parseNumbers)

import Parser exposing ((|.), (|=), Parser)
import Parser.Extras


parseNumbers : String -> Maybe (List Float)
parseNumbers str =
    case Parser.run numbersParser str of
        Ok numbers ->
            Just numbers

        Err _ ->
            Nothing


numbersParser : Parser (List Float)
numbersParser =
    Parser.Extras.many signedNumber


signedNumber : Parser Float
signedNumber =
    Parser.oneOf [ negativeNumber, Parser.float ]


negativeNumber : Parser Float
negativeNumber =
    (Parser.succeed identity
        |. Parser.symbol "-"
        |= Parser.float
    )
        |> Parser.map (\x -> -x)
