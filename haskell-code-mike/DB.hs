module DB where

import Data.Map.Strict as Map
import Data.Map.Strict (Map, (!))

{-
DSL für Datenbank-Programme:

  put "Mike" 50
  x = get "Mike"
  put "Mike" (x + 1)
  y = get "Mike"
  return (show (x + y))
-}

{- -- FAIL: 

data DBCommand result =
    Put String Integer 
  | Get String
  | Return result

type DBProgram result = [DBCommand result]

p1 = [Put "Mike" 50, Get "Mike", Return "foo"]
-- ^^^ können Dingen keinen Namen geben
-}

data DB a =
    Get String (Integer -> DB a) -- "continuation"
  | Put String Integer (() -> DB a)
  | Return a

p1 :: DB String
p1 = Put "Mike" 50 (\() ->
     Get "Mike" (\ x ->
     Put "Mike" (x + 1) (\() ->
     Get "Mike" (\ y ->
     Return (show (x + y))))))

get :: String -> DB Integer 
get key = Get key Return -- (\ value -> Return value)

put :: String -> Integer -> DB ()
put key value = Put key value Return

c1 :: DB ()
c1 = put "Mike" 50
c2 :: DB Integer
c2 = get "Mike"

splice :: DB a -> (a -> DB b) -> DB b
splice (Get key cont) next = 
    Get key (\ value -> splice (cont value) next)
splice (Put key value cont) next = 
    Put key value (\() ->
                    splice (cont ()) next)
splice (Return result) next = next result

instance Applicative DB where
    
instance Monad DB where
    (>>=) = splice
    return = Return

p1' :: DB String
p1' = put "Mike" 50 `splice` (\() ->
      get "Mike" `splice` (\x ->
      put "Mike" (x+1) `splice` (\() ->
      get "Mike" `splice` (\y ->
      Return (show (x + y))))))

runDB :: Map String Integer -> DB a -> a
runDB mp (Get key cont) =
    let value = mp ! key
    in runDB mp (cont value)
runDB mp (Put key value cont) =
    let mp' = Map.insert key value mp
    in runDB mp' (cont ())
runDB mp (Return result) = result