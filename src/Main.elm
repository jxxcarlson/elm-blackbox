port module Main exposing (main)

import BlackBox
import Cmd.Extra exposing (withCmd, withCmds, withNoCmd)
import Json.Decode as D
import Json.Encode as E
import Platform exposing (Program)


port get : (String -> msg) -> Sub msg


port put : String -> Cmd msg


port sendFileName : E.Value -> Cmd msg


port receiveData : (E.Value -> msg) -> Sub msg


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { fileContents : Maybe String }


type Msg
    = Input String
    | ReceivedDataFromJS E.Value


type alias Flags =
    ()


init : () -> ( Model, Cmd Msg )
init _ =
    { fileContents = Nothing } |> withNoCmd


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ get Input, receiveData ReceivedDataFromJS ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            case input == "" of
                True ->
                    model |> withNoCmd

                False ->
                    commandProcessor model input

        ReceivedDataFromJS value ->
            case decodeFileContents value of
                Nothing ->
                    model |> withCmd (put "Couldn't load file")

                Just data ->
                    { model | fileContents = Just data } |> withCmd (put "File contents stored")


commandProcessor : Model -> String -> ( Model, Cmd Msg )
commandProcessor model cmdString =
    let
        args =
            String.split " " cmdString
                |> List.map String.trim
                |> List.filter (\item -> item /= "")

        cmd =
            List.head args

        arg =
            List.head (List.drop 1 args)
    in
    case ( cmd, arg ) of
        ( Just ":get", Just fileName ) ->
            loadFile model fileName

        ( Just ":help", _ ) ->
            model |> withCmd (put helpText)

        ( Just ":show", _ ) ->
            model |> withCmd (put (model.fileContents |> Maybe.withDefault "no file loaded"))

        ( Just ":app", _ ) ->
            case model.fileContents of
                Nothing ->
                    model |> withCmd (put (model.fileContents |> Maybe.withDefault "no file loaded"))

                Just str ->
                    model |> withCmd (put (BlackBox.transform (String.trim str)))

        ( _, _ ) ->
            model |> withCmd (put <| BlackBox.transform cmdString)


loadFile model fileName =
    ( model, loadFileCmd fileName )


loadFileCmd : String -> Cmd msg
loadFileCmd filePath =
    sendFileName (E.string <| filePath)


decodeFileContents : E.Value -> Maybe String
decodeFileContents value =
    case D.decodeValue D.string value of
        Ok str ->
            Just str

        Err _ ->
            Nothing


helpText =
    """Commands:

    :help             help
    :get FILE         load FILE into memory
    :show             show contents of memory
    :app              apply BlackBox.transform to the contents of memory

    STRING            apply BlackBox.transform to STRING

Example using the default BlackBox:

    > foo
    Characters: 3

    > :get src/repl.js
    File contents stored
    
    > :app
    Characters: 842
"""
