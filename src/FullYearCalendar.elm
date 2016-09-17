module FullYearCalendar exposing (..)

{-| This library builds a full year calendar for the selected year

# Definition
@docs monthDayCountInYear

-}

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


type Msg
    = SelectDate Date


type alias Year =
    Int


type alias Event =
    {}


type alias Cell =
    { date : Date
    , events : Bool
    }


type alias Model =
    { selectedYear : Year
    , selectedDate : Maybe Date
    , cells : List Cell
    }


dateConfig : Date.Extra.Config.Config
dateConfig =
    getConfig "en_us"


dateFormat : String
dateFormat =
    isoDateFormat


init : Model
init =
    { selectedYear = 2016
    , selectedDate = Nothing
    , cells = (initCells 2016)
    }


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
    { date = date, events = False }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        SelectDate date ->
            { model | selectedDate = Just date }



--- VIEW


view : Model -> Html Msg
view model =
    div []
        (calendarCells model.cells)


calendarCells : List Cell -> List (Html Msg)
calendarCells cells =
    List.map calendarCell cells


calendarCell : Cell -> Html Msg
calendarCell cell =
    div
        [ class "calendar-cell"
        , onClick (SelectDate cell.date)
        ]
        [ text (cellFormat cell) ]


cellFormat : Cell -> String
cellFormat cell =
    format dateConfig "%-d" cell.date
