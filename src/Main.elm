module Main exposing (..)

{-| This library builds a full year calendar for the selected year

# Definition
@docs monthDayCountInYear

-}

import Html.App
import Html exposing (Html)
import Date exposing (..)
import Date.Extra.Core exposing (..)
import Date.Extra.Utils exposing (dayList)
import Debug


type Msg
    = NoOp


type alias Year =
    Int


type alias Event =
    {}


type alias Cell =
    { date : Date
    , events : List Event
    }


type alias Model =
    { selectedYear : Year
    , cells : List Cell
    }


init : ( Model, Cmd Msg )
init =
    ( { selectedYear = 2016
      , cells = (initCells 2016)
      }
    , Cmd.none
    )


initCells : Year -> List Cell
initCells year =
    List.map buildEmptyCells (allDaysOfTheYear year)


allDaysOfTheYear : Year -> List Date
allDaysOfTheYear year =
    dayList (yearToDayLength year) (firstDayOfTheYear year)


firstDayOfTheYear : Year -> Date
firstDayOfTheYear year =
    Date.fromString ("01/01/" ++ (toString year))
        |> Result.withDefault (Date.fromTime 0)


{-|
-}
buildEmptyCells : Date -> Cell
buildEmptyCells date =
    { date = date, events = [ {} ] }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )



--- VIEW


view : Model -> Html Msg
view model =
    let
        _ =
            Debug.log "model: " model
    in
        Html.div []
            []



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
