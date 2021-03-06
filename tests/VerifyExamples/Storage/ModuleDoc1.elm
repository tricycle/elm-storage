module VerifyExamples.Storage.ModuleDoc1 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Expect
import Storage exposing (..)
import Storage.Value as Value
import Test


configuration : Storage
configuration =
    Storage.fromList
        [ ( "config.item.a", Value.string "some value" )
        , ( "config.item.b", Value.float 1.5 )
        ]


spec1 : Test.Test
spec1 =
    Test.test "Module VerifyExamples: \n\n    Storage.getFloat \"config.item.a\" configuration\n    --> Nothing" <|
        \() ->
            Expect.equal
                (Storage.getFloat "config.item.a" configuration)
                Nothing
