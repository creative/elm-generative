module Example.Turtle exposing (..)

import Draw exposing (..)
import LSystem
import LSystem.Turtle exposing (State(..), turtle)
import Svg.PathD as PathD exposing (d_)
import Svg exposing (Svg)
import Svg.Attributes exposing (transform)
import Html exposing (Html, text)


type Model
    = Model Int (List State)


type Configuration
    = Configuration ( Float, Float ) Float


rule : LSystem.Rule State
rule state =
    case state of
        D ->
            [ D, D, R, D, L, D, R, D, R, D, D ]

        S ->
            [ S ]

        L ->
            [ L ]

        R ->
            [ R ]


type Msg
    = Iterate
    | Draw


init : ( Model, Cmd Msg )
init =
    update Iterate (Model 4 [ D, R, D, R, D, R, D ])


draw : Model -> Configuration -> Svg Msg
draw (Model _ states) (Configuration p0 a0) =
    Svg.path
        [ d_ <| [ PathD.M p0 ] ++ turtle states p0 a0
        , Svg.Attributes.strokeWidth "0.2"
        ]
        []


view : Model -> Html Msg
view model =
    case model of
        Model n state ->
            a4Landscape
                []
                [ g
                    [ transform <| Draw.translate 125 70 ++ Draw.scale 2 ]
                    [ draw model (Configuration ( 0, 0 ) 0) ]
                ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Iterate, Model n state ) ->
            case n > 0 of
                True ->
                    update Iterate <|
                        Model (n - 1) (LSystem.apply rule state)

                False ->
                    update Draw model

        ( Draw, model ) ->
            ( model, Cmd.none )