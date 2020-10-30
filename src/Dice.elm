module Dice exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { dieFace : Int
    , dieFace2 : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 3 3
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | NewFace ( Int, Int )


dice : Random.Generator Int
dice =
    Random.int 1 6


dicePair : Random.Generator ( Int, Int )
dicePair =
    Random.pair dice dice


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace dicePair
            )

        NewFace ( value, value2 ) ->
            ( { model | dieFace = value, dieFace2 = value2 }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ Html.text (String.fromInt model.dieFace) ]
        , h1 [] [ Html.text (String.fromInt model.dieFace2) ]
        , viewDice model.dieFace
        , viewDice model.dieFace2
        , button [ onClick Roll ] [ Html.text "Roll" ]
        ]


viewDice : Int -> Html Msg
viewDice value =
    svg
        [ width "120"
        , height "120"
        , viewBox "0 0 120 120"
        , fill "white"
        , stroke "black"
        , strokeWidth "3"
        ]
        (List.append
            [ rect
                [ x "1"
                , y "1"
                , width "100"
                , height "100"
                , rx "15"
                , ry "15"
                ]
                []
            ]
            (svgCirclesForDieFace value)
        )


svgCirclesForDieFace : Int -> List (Svg Msg)
svgCirclesForDieFace dieFace =
    case dieFace of
        1 ->
            [ circle [ cx "50", cy "50", r "10", fill "black" ] [] ]

        2 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        3 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "50", cy "50", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        4 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            , circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        5 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            , circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            , circle [ cx "50", cy "50", r "10", fill "black" ] []
            ]

        6 ->
            [ circle [ cx "25", cy "20", r "10", fill "black" ] []
            , circle [ cx "25", cy "50", r "10", fill "black" ] []
            , circle [ cx "25", cy "80", r "10", fill "black" ] []
            , circle [ cx "75", cy "20", r "10", fill "black" ] []
            , circle [ cx "75", cy "50", r "10", fill "black" ] []
            , circle [ cx "75", cy "80", r "10", fill "black" ] []
            ]

        _ ->
            [ circle [ cx "50", cy "50", r "50", fill "red", stroke "none" ] [] ]
