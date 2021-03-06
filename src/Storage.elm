module Storage exposing
    ( Storage
    , empty, singleton, insert, update, remove
    , isEmpty, member, size, get, getBool, getFloat, getInt, getString, getJson, getStringUnsafe
    , keys, values, toList, fromList
    , union, intersect, diff, merge
    )

{-|

@docs Storage


# Build

    empty
        |> insert "foo" (Value.string "bar")
    --> fromList [ ( "foo", Value.string "bar" ) ]

@docs empty, singleton, insert, update, remove


# Query

@docs isEmpty, member, size, get, getBool, getFloat, getInt, getString, getJson, getStringUnsafe


# Lists

@docs keys, values, toList, fromList


# Combine

@docs union, intersect, diff, merge

-}

import Internal.Storage as Storage
import Internal.Storage.Value exposing (Value)
import Json.Encode as Json


{-| A storage container of keys and values.

    import Storage exposing (Storage)
    import Storage.Value as Value

    configuration: Storage
    configuration =
        Storage.fromList [
        ("config.item.a", Value.string "some value")
        , ("config.item.b", Value.float 1.5)
        ]


    Storage.getString "config.item.a" configuration
    --> Just "some value"

    Storage.getString "config.item.b" configuration
    --> Nothing

    Storage.getStringUnsafe "config.item.a" configuration
    --> "some value"

    Storage.getStringUnsafe "config.item.b" configuration
    --> "1.5"

    Storage.getFloat "config.item.a" configuration
    --> Nothing

    Storage.getFloat "config.item.b" configuration
    --> Just "1.5"

-}
type alias Storage =
    Storage.Storage


{-| Create an empty Storage container
-}
empty : Storage
empty =
    Storage.empty


{-| Create a Storage container with one String-Value pair.

    singleton "fruit" (Value.string "apple")
    --> fromList [ ( "fruit", Value.string "apple" ) ]

-}
singleton : String -> Value -> Storage
singleton =
    Storage.singleton


{-| Insert a String-Value pair into a Storage container. Replaces value when there is a collision.

    empty
        |> insert "fruit" (Value.string "apple")
        |> insert "fruit" (Value.string "banana")
    --> fromList [ ( "fruit", Value.string "banana" ) ]

-}
insert : String -> Value -> Storage -> Storage
insert =
    Storage.insert


{-| Update a Value for a specific key with a given function.

    empty
        |> insert "fruit" (Value.string "apple")
        |> update "fruit" (Maybe.map (\_ -> Value.string "banana"))
    --> fromList [ ( "fruit", Value.string "banana" ) ]

-}
update : String -> (Maybe Value -> Maybe Value) -> Storage -> Storage
update =
    Storage.update


{-| Remove a String-Value pair from a Storage container. If the key is not found, no changes are made.

    empty
        |> insert "fruit" (Value.string "apple")
        |> remove "fruit"
    --> empty

-}
remove : String -> Storage -> Storage
remove =
    Storage.remove


{-| Determine if a Storage container is empty.

    isEmpty empty
    --> True

    isEmpty (fromList [])
    --> True

    empty
        |> insert "fruit" (Value.string "apple")
        |> isEmpty
    --> False

    empty
        |> insert "fruit" (Value.string "apple")
        |> remove "fruit"
        |> isEmpty
    --> True

-}
isEmpty : Storage -> Bool
isEmpty =
    Storage.isEmpty


{-| Determine if a key is in a Storage.

    empty
        |> insert "fruit" (Value.string "apple")
        |> member "fruit"
    --> True

    empty
        |> insert "fruit" (Value.string "apple")
        |> member "apple"
    --> False

-}
member : String -> Storage -> Bool
member =
    Storage.member


{-| Get the Value associated with a key. If the key is not found, return Nothing.
This is useful when you are not sure if a key will be in the Storage.

    empty
        |> insert "fruit" (Value.string "apple")
        |> get "fruit"
    --> Just (Value.string "apple")

    empty
        |> insert "fruit" (Value.string "apple")
        |> get "apple"
    --> Nothing

-}
get : String -> Storage -> Maybe Value
get =
    Storage.get


{-| Safely get the String associated with a key. If the key is not found OR if
the value is not a String, return Nothing.

    empty
        |> insert "fruit" (Value.string "apple")
        |> getString "fruit"
        --> Just "apple"

-}
getString : String -> Storage -> Maybe String
getString =
    Storage.getString


{-| Safely get the Bool associated with a key. If the key is not found OR if
the value is not a Bool, return Nothing.

    empty
        |> insert "is.cool" (Value.bool True)
        |> getBool "is.cool"
        --> Just True

-}
getBool : String -> Storage -> Maybe Bool
getBool =
    Storage.getBool


{-| Safely get the Float associated with a key. If the key is not found OR if
the value is not a Float, return Nothing.

    empty
        |> insert "velocity" (Value.float 1.6)
        |> getFloat "velocity"
        --> Just 1.6

-}
getFloat : String -> Storage -> Maybe Float
getFloat =
    Storage.getFloat


{-| Safely get the Int associated with a key. If the key is not found OR if
the value is not a Int, return Nothing.

    empty
        |> insert "moons" (Value.int 1)
        |> getInt "moons"
        --> Just 1

-}
getInt : String -> Storage -> Maybe Int
getInt =
    Storage.getInt


{-| Safely get the Json associated with a key. If the key is not found OR if
the value is not a Json, return Nothing.
-}
getJson : String -> Storage -> Maybe Json.Value
getJson =
    Storage.getJson


{-| Unsafely get **a** String associated with a key. If the key is not found
return an empty String ("")
-}
getStringUnsafe : String -> Storage -> String
getStringUnsafe =
    Storage.getStringUnsafe


{-| Determine the number of String-Value pairs in the Storage container.

    fromList [("foo", Value.empty)]
    |> size
    --> 1

-}
size : Storage -> Int
size =
    Storage.size


{-| Get all of the keys in a Storage container, sorted from lowest to highest.

    fromList [("foo", Value.empty), ("bar", Value.empty)]
        |> keys
    --> ["bar", "foo"]

-}
keys : Storage -> List String
keys =
    Storage.keys


{-| Get all of the values in a Storage container, in the order of their keys.

    fromList [("foo", Value.string "a"), ("bar", Value.string "b")]
        |> values
    --> [Value.string "b", Value.string "a"]

-}
values : Storage -> List Value
values =
    Storage.values


{-| Convert a dictionary into an Storage container list of key-StoageItem pairs, sorted by keys.

    insert "fruit" (Value.string "apple") empty
    |> toList
    --> [ ( "fruit", Value.string "apple" ) ]

-}
toList : Storage -> List ( String, Value )
toList =
    Storage.toList


{-| Convert an association list into a Storage container.

    fromList [
        ( "fruit", Value.string "apple" )
    ]
    --> insert "fruit" (Value.string "apple") empty

-}
fromList : List ( String, Value ) -> Storage
fromList =
    Storage.fromList


{-| Combine two Storage containers. If there is a collision, preference is given to the first Storage container.

    union
        ( fromList [("a", Value.string "a1"), ("c", Value.string "c1")] )
        ( fromList [("a", Value.string "a2"), ("b2", Value.string "b2")] )
    --> fromList [ ( "a", Value.string "a1" ), ( "b", Value.string "b2" ), ( "c", Value.string "c1" ) ]

-}
union : Storage -> Storage -> Storage
union =
    Storage.union


{-| Keep a String-value pair when its key appears in the second Storage container. Preference is given to values in the first Storage container.

    intersect
        ( fromList [("a", Value.string "a1"), ("c", Value.string "c1")] )
        ( fromList [("a", Value.string "a2"), ("b2", Value.string "b2")] )
    --> fromList [ ( "a", Value.string "a1" )]

-}
intersect : Storage -> Storage -> Storage
intersect =
    Storage.intersect


{-| Keep a String-value pair when its key does not appear in the second Storage container.

    diff
        ( fromList [("a", Value.string "a1"), ("c", Value.string "c1")] )
        ( fromList [("a", Value.string "a2"), ("b2", Value.string "b2")] )
    --> fromList [ ("c", Value.string "c1") ]

-}
diff : Storage -> Storage -> Storage
diff =
    Storage.diff


{-| The most general way of combining two Storage containers. You provide three accumulators for when a given key appears:

  - Only in the left Storage container.
  - In both Storage containers.
  - Only in the right Storage container.

You then traverse all the keys from lowest to highest, building up whatever you want.

-}
merge :
    (String -> Value -> result -> result)
    -> (String -> Value -> Value -> result -> result)
    -> (String -> Value -> result -> result)
    -> Storage
    -> Storage
    -> result
    -> result
merge =
    Storage.merge
