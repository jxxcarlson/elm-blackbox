module Statistics.ParseCommands exposing (Commands, parseCommands)

import Parser exposing (..)
import Parser.Extras


type Command
    = Ignore Int
    | Rows Int Int
    | Column Int


parseCommands : String -> Maybe (List Command)
parseCommands input =
    case run commands input of
        Ok output ->
            Just output

        Err _ ->
            Nothing


commands : Parser (List Command)
commands =
    Parser.Extras.many command


command : Parser Command
command =
    oneOf [ ignore, column, rows ]


ignore : Parser Command
ignore =
    succeed Ignore
        |. symbol "ignore="
        |= int
        |. spaces


column : Parser Command
column =
    succeed Column
        |. symbol "column="
        |= int
        |. spaces


rows : Parser Command
rows =
    succeed Rows
        |. symbol "rows="
        |= int
        |. symbol ":"
        |= int
        |. spaces
