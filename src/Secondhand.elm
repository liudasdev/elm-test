module Secondhand exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, map4, string)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success (List Item)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, loadItems )



-- UPDATE


type Msg
    = LoadItems
    | GotItems (Result Http.Error (List Item))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadItems ->
            ( Loading, loadItems )

        GotItems result ->
            case result of
                -- FIXME
                Ok items ->
                    ( Success items, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewItems model
        ]


viewItems : Model -> Html Msg
viewItems model =
    case model of
        Failure ->
            div []
                [ text "Failed to load. "
                , button [ onClick LoadItems ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success items ->
            ul []
                (List.map viewItem items)


viewItem : Item -> Html Msg
viewItem { title, price, link, image } =
    li []
        [ a [ href link ]
            [ div [] [ img [ height 200, src image ] [] ]
            , div [] [ text title ]
            , div [] [ text price ]
            ]
        ]



-- HTTP


type alias Item =
    { title : String
    , image : String
    , link : String -- FIXME: type url
    , price : String
    }


loadItems : Cmd Msg
loadItems =
    Http.get
        { url = "http://localhost:3000/items"
        , expect = Http.expectJson GotItems itemsDecoder
        }


itemsDecoder : Decoder (List Item)
itemsDecoder =
    field "items" (Json.Decode.list itemDecoder)


itemDecoder : Decoder Item
itemDecoder =
    map4 Item
        (field "title" string)
        (field "image" string)
        (field "link" string)
        (field "price" string)
