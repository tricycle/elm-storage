module VerifyExamples.Storage.Value.ToInt0 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Expect
import Storage.Value exposing (..)
import Test


spec0 : Test.Test
spec0 =
    Test.test "#toInt: \n\n    toInt (float 1.0)\n    --> Nothing" <|
        \() ->
            Expect.equal
                (toInt (float 1.0))
                Nothing