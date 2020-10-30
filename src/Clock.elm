module Clock exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type TimeStatus
    = On
    | Off


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , status : TimeStatus
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) On
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | ToggleClick
    | ToggleStatus Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }, Cmd.none )

        ToggleClick ->
            ( model, Task.perform ToggleStatus Time.now )

        ToggleStatus time ->
            case model.status of
                On ->
                    ( { model | status = Off }, Cmd.none )

                Off ->
                    ( { model | status = On, time = time }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.status of
        On ->
            Time.every 1000 Tick

        Off ->
            Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            Time.toHour model.zone model.time

        minute =
            Time.toMinute model.zone model.time

        second =
            Time.toSecond model.zone model.time

        digitalClockLabel =
            String.fromInt hour ++ ":" ++ String.fromInt minute ++ ":" ++ String.fromInt second

        buttonLabel =
            case model.status of
                On ->
                    "STOP"

                Off ->
                    "START"
    in
    div []
        [ div []
            [ h1 [] [ Html.text digitalClockLabel ]
            , button [ onClick ToggleClick ] [ Html.text buttonLabel ]
            ]
        , div []
            [ viewAnalogClock hour minute second
            ]
        ]


viewAnalogClock : Int -> Int -> Int -> Html msg
viewAnalogClock hour minute second =
    svg
        [ viewBox "0 0 400 400"
        , width "400"
        , height "400"
        ]
        [ circle [ cx "200", cy "200", r "120", fill "#1293D8" ] []
        , viewHand 6 60 (toFloat hour / 12) "white"
        , viewHand 6 90 (toFloat minute / 60) "white"
        , viewHand 3 90 (toFloat second / 60) "red"
        ]


viewHand : Int -> Float -> Float -> String -> Svg msg
viewHand width length turns color =
    let
        t =
            2 * pi * (turns - 0.25)

        x =
            200 + length * cos t

        y =
            200 + length * sin t
    in
    line
        [ x1 "200"
        , y1 "200"
        , x2 (String.fromFloat x)
        , y2 (String.fromFloat y)
        , stroke color
        , strokeWidth (String.fromInt width)
        , strokeLinecap "round"
        ]
        []
