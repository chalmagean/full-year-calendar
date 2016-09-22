module FullYearCalendar exposing (view, update, Msg)

{-|

  This library builds a full year calendar for the specified year.

-}

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, classList)
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


type alias Cell =
    { date : Date
    , events : Bool
    }


initCells : Year -> List Cell
initCells year =
    List.map buildEmptyCells (allDaysOfTheYear year)


{-|
-}
buildEmptyCells : Date -> Cell
buildEmptyCells date =
    { date = date, events = False }


allDaysOfTheYear : Year -> List Date
allDaysOfTheYear year =
    dayList (yearToDayLength year) (firstDayOfTheYear year)


firstDayOfTheYear : Year -> Date
firstDayOfTheYear year =
    dateFromFields year Jan 1 0 0 0 0


dateConfig : Date.Extra.Config.Config
dateConfig =
    getConfig "en_us"


dateFormat : String
dateFormat =
    isoDateFormat



-- UPDATE


update : Msg -> Maybe Date
update msg =
    case msg of
        SelectDate date ->
            Just date



--- VIEW


view : Html Msg
view =
    div []
        (calendarCells (initCells 2016))


calendarCells : List Cell -> List (Html Msg)
calendarCells cells =
    List.map calendarCell cells


calendarCell : Cell -> Html Msg
calendarCell cell =
    div
        [ classList [ ( "fyc-cell", True ), ( "fyc-cell-first-day", (firstDayOfMonth cell.date) ) ]
        , onClick (SelectDate cell.date)
        ]
        [ text (cellText cell) ]


cellText : Cell -> String
cellText cell =
    if (Date.day cell.date) == 1 then
        toString (Date.month cell.date) ++ " " ++ (cellFormat cell)
    else
        cellFormat cell


cellFormat : Cell -> String
cellFormat cell =
    format dateConfig "%-d" cell.date


firstDayOfMonth : Date -> Bool
firstDayOfMonth date =
    if (Date.day date) == 1 then
        True
    else
        False
