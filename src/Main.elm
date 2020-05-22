port module Main exposing (main)

import Cmd.Extra exposing (withCmd, withCmds, withNoCmd)
import Json.Decode as D
import Json.Encode as E
import Platform exposing (Program)
import Statistics as Blackbox


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
    { residualCommand : String, fileContents : Maybe String }


type Msg
    = Input String
    | ReceivedDataFromJS E.Value


type alias Flags =
    ()


init : () -> ( Model, Cmd Msg )
init _ =
    { residualCommand = "", fileContents = Nothing } |> withNoCmd


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
                    let
                        ( cmd, residualCmd ) =
                            splitCommand input
                    in
                    commandProcessor { model | residualCommand = residualCmd } cmd

        ReceivedDataFromJS value ->
            case decodeFileContents value of
                Nothing ->
                    model |> withCmd (put "Couldn't load file")

                Just data ->
                    let
                        cleanData =
                            removeComments data

                        input =
                            case model.residualCommand == "" of
                                True ->
                                    cleanData

                                False ->
                                    ":" ++ model.residualCommand ++ " " ++ cleanData
                    in
                    { model | fileContents = Just data } |> withCmd (put <| Blackbox.transform input)


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
            List.drop 1 args
                |> String.join " "
    in
    case ( cmd, arg ) of
        ( Just ":get", fileName ) ->
            loadFile model fileName

        ( Just ":help", _ ) ->
            model |> withCmd (put Blackbox.helpText)

        ( Just ":show", _ ) ->
            model |> withCmd (put (model.fileContents |> Maybe.withDefault "no file loaded"))

        ( Just ":head", _ ) ->
            model
                |> withCmd
                    (put
                        (model.fileContents
                            |> Maybe.map (head 5)
                            |> Maybe.withDefault "no file loaded"
                        )
                    )

        ( Just ":tail", _ ) ->
            model
                |> withCmd
                    (put
                        (model.fileContents
                            |> Maybe.map (tail 5)
                            |> Maybe.withDefault "no file loaded"
                        )
                    )

        ( Just ":app", arg_ ) ->
            case model.fileContents of
                Nothing ->
                    model |> withCmd (put (model.fileContents |> Maybe.withDefault "no file loaded"))

                Just str ->
                    let
                        arg__ =
                            case arg_ == "" of
                                True ->
                                    ""

                                False ->
                                    arg_
                                        |> (\x -> ":" ++ x ++ "\n")
                    in
                    model |> withCmd (put (Blackbox.transform <| (arg__ ++ removeComments str)))

        ( _, _ ) ->
            model |> withCmd (put <| Blackbox.transform (removeComments cmdString))



-- FILE HANDLING


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



-- HELPERS


splitCommand : String -> ( String, String )
splitCommand input =
    let
        args =
            input
                |> String.split " "
                |> List.filter (\s -> s /= "")

        residualCmd =
            args
                |> List.drop 2
                |> String.join " "

        cmd =
            args
                |> List.take 2
                |> String.join " "
                |> String.trim
    in
    ( cmd, residualCmd )


removeComments : String -> String
removeComments input =
    input
        |> String.lines
        |> List.filter (\line -> String.left 1 line /= "#")
        |> String.join "\n"
        |> String.trim


head : Int -> String -> String
head k input =
    input
        |> String.lines
        |> List.take k
        |> String.join "\n"


tail : Int -> String -> String
tail k input =
    let
        lines =
            String.lines input

        n =
            List.length lines
    in
    lines
        |> List.drop (n - k - 1)
        |> String.join "\n"
