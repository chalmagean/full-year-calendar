module Main exposing (..)

import Html.App
import Html exposing (Html)


type Msg
    = NoOp


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )



--- VIEW


view : Model -> Html Msg
view model =
    Html.text "TODO"



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
