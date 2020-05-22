module Statistics.Commands exposing (Command(..), parse)

import Parser exposing (..)
import Parser.Extras


type Command
    = Ignore Int
    | Rows Int Int
    | Column Int
    | F Format


type Format
    = Csv
    | SpaceDelimited


parse : String -> Maybe (List Command)
parse input =
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
    oneOf [ ignore, column, rows, format ]


format : Parser Command
format =
    oneOf [ csv, spaceDelimited ]


csv : Parser Command
csv =
    succeed (F Csv)
        |. symbol "csv"
        |. spaces


spaceDelimited : Parser Command
spaceDelimited =
    succeed (F SpaceDelimited)
        |. symbol "space"
        |. spaces


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
