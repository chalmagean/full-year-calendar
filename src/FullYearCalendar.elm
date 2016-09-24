module FullYearCalendar exposing (view, update, Msg)

{-|

  This library builds a full year calendar for the specified year.

-}

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, classList)
import Date exposing (..)
import Date.Extra.Core exposing (..)
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
    , hasEvents : Bool
    }


initCells : List Date -> Year -> List Cell
initCells eventDates year =
    List.map buildEmptyCells (allDaysOfTheYear year)
        |> populateEvents eventDates


populateEvents : List Date -> List Cell -> List Cell
populateEvents eventDates calendarCells =
    List.map (\cell -> { cell | hasEvents = List.member cell.date eventDates }) calendarCells


{-|
-}
buildEmptyCells : Date -> Cell
buildEmptyCells date =
    { date = date, hasEvents = False }


allDaysOfTheYear : Year -> List Date
allDaysOfTheYear year =
    dayList (yearToDayLength year) (firstDayOfTheYear year)


firstDayOfTheYear : Year -> Date
firstDayOfTheYear year =
    Date.fromString ((toString year) ++ "-01-01T00:00:00.000Z")
        |> Result.withDefault (Date.fromTime 0)


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


view : List Date -> Html Msg
view eventDates =
    let
        cells =
            initCells eventDates 2016
    in
        div []
            (calendarCells cells)


calendarCells : List Cell -> List (Html Msg)
calendarCells cells =
    List.map calendarCell cells


calendarCell : Cell -> Html Msg
calendarCell cell =
    div
        [ classList
            [ ( "fyc-cell", True )
            , ( "fyc-cell-first-day", (firstDayOfMonth cell.date) )
            , ( "fyc-cell-with-events", (cell.hasEvents == True) )
            ]
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
