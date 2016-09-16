module Main exposing (..)

{-| This library builds a full year calendar for the selected year

# Definition
@docs monthDayCountInYear

-}

import Html.App
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Date exposing (..)
import Date.Extra.Core exposing (..)
import Date.Extra.Create exposing (dateFromFields)
import Date.Extra.Utils exposing (dayList)
import Date.Extra.Config
import Date.Extra.Config.Configs exposing (getConfig)
import Date.Extra.Format exposing (format, isoDateFormat)
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


dateConfig : Date.Extra.Config.Config
dateConfig =
    getConfig "en_us"


dateFormat : String
dateFormat =
    isoDateFormat


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
    dateFromFields year Jan 1 0 0 0 0


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
        div []
            (calendarCells model.cells)


calendarCells : List Cell -> List (Html Msg)
calendarCells cells =
    List.map calendarCell cells


calendarCell : Cell -> Html Msg
calendarCell cell =
    div
        [ class "calendar-cell"
        , onClick NoOp
        ]
        [ text (cellFormat cell) ]


cellFormat : Cell -> String
cellFormat cell =
    format dateConfig "%d" cell.date



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
