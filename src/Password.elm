module Password exposing (..)

-- Input a user name and password. Make sure the password matches.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/forms.html
--

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


init : Model
init =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( valid, info ) =
            validate model

        color =
            if valid then
                "green"

            else
                "red"
    in
    div [ style "color" color ] [ text info ]


validate : Model -> ( Bool, String )
validate model =
    if not (validLength model.password) then
        ( False, "Should be at least 8 characters LENGTH" )

    else if not (model.password == model.passwordAgain) then
        ( False, "Passwords should MATCH" )

    else if not (containsNumeric model.password) then
        ( False, "Should contain at least 1 NUMERIC character" )

    else if not (containsUpperCase model.password) then
        ( False, "Should contain at least UPPER case character" )

    else if not (containsLowerCase model.password) then
        ( False, "Should contain at least LOWER case character" )

    else
        ( True, "OK" )


containsNumeric : String -> Bool
containsNumeric s =
    String.toList s |> List.any Char.isDigit


containsUpperCase : String -> Bool
containsUpperCase s =
    String.toLower (String.toUpper s) /= s


containsLowerCase : String -> Bool
containsLowerCase s =
    String.toUpper (String.toLower s) /= s


validLength : String -> Bool
validLength value =
    String.length value >= 8
