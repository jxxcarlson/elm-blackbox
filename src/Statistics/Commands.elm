module Statistics.Commands exposing (..)

-- exposing (Command(..), parse)

import Parser exposing (..)
import Parser.Extras


type Command
    = Ignore Int
    | Rows Int Int
    | Column Int Format


type Format
    = Csv
    | Space


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
    oneOf [ ignore, column, rows ]


format : Parser Format
format =
    oneOf [ csv, spaceDelimited ]


csv : Parser Format
csv =
    succeed Csv
        |. symbol "csv"
        |. spaces


spaceDelimited : Parser Format
spaceDelimited =
    succeed Space
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
        |. symbol ":"
        |= format
        |. spaces


rows : Parser Command
rows =
    succeed Rows
        |. symbol "rows="
        |= int
        |. symbol ":"
        |= int
        |. spaces
