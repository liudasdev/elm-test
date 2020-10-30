module Foos exposing (..)

-- import Random.Pcg.Extended exposing (Seed, initialSeed, step)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Random
import Task
import UUID



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Player =
    { uid : String
    , name : String
    }


type alias Model =
    { players : Dict String Player
    , currentSeed : Random.Seed
    , currentUuid : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { currentSeed = Random.initialSeed 12345
      , currentUuid = Nothing
      , players = Dict.empty
      }
    , Task.perform Add
    )



-- UPDATE


type Msg
    = Add String
    | Remove String
    | Change String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add value ->
            case model.currentUuid of
                Just uid ->
                    ( { model
                        | players = Dict.insert uid (Player uid value) model.players
                      }
                    , Cmd.none
                    )

                Nothing ->
                    let
                        ( newUuid, newSeed ) =
                            Random.step UUID.generator model.currentSeed
                    in
                    ( { model
                        | currentUuid = Just (UUID.toString newUuid)
                        , currentSeed = newSeed
                      }
                    , Add value
                    )

        Remove uid ->
            ( { model
                | players = Dict.remove uid model.players
              }
            , Cmd.none
            )

        Change uid value ->
            ( { model | players = Dict.update uid (updatePlayer value) model.players }
            , Cmd.none
            )


updatePlayer : String -> Maybe Player -> Maybe Player
updatePlayer value player =
    case player of
        Just player2 ->
            Just { player2 | name = value }

        Nothing ->
            Nothing


hasEmptyName model =
    List.map .name model.players
        |> List.member ""



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (Add "") ] [ text "Add" ]
        , div [] (List.map viewPlayerInput <| Dict.values model.players)
        ]


viewPlayerInput : Player -> Html Msg
viewPlayerInput player =
    div []
        [ input [ placeholder "Add player name", value player.name, onInput (Change player.uid) ] []
        , span [] [ text player.uid ]
        ]
