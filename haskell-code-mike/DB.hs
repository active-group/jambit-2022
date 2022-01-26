module DB where

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
    Get String (Integer -> DB a)
  | Put String Integer (() -> DB a)
  | Return a

p1 :: DB String
p1 = Put "Mike" 50 (\() ->
     Get "Mike" (\ x ->
     Put "Mike" (x + 1) (\() ->
     Get "Mike" (\ y ->
     Return (show (x + y))))))

