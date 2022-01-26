module Intro where

x :: Integer
x = 7

y :: Integer
y = x + 9

f :: Integer -> Integer
f n = n + 1

-- Ein Haustier ist eins der folgenden:
-- - Hund
-- - Katze
-- - Schlange
data Pet = Dog | Cat | Snake 
  deriving Show
-- data: neuer Datentyp

-- Ist ein Haustier niedlich?
isCute :: Pet -> Bool 
isCute Dog = True
isCute Cat = True
isCute Snake = False

-- Ein Gürteltier hat folgende Eigenschaften:
-- - tot oder lebendig
-- - Gewicht
data Liveness = Dead | Alive
  deriving Show

-- Typalias
type Weight = Integer

data Dillo = MkDillo { dilloLiveness :: Liveness,
                       dilloWeight :: Weight }
  deriving Show
---  ^^^^^ Datentyp
---          ^^^^^ Konstruktor

dillo1 :: Dillo
dillo1 = MkDillo {dilloLiveness = Alive, dilloWeight = 10}
dillo2 = MkDillo Dead 8

-- Gürteltier überfahren
runOverDillo :: Dillo -> Dillo
-- runOverDillo dillo = MkDillo {dilloLiveness = Dead, dilloWeight = dilloWeight dillo}
-- dilloLiveness dillo ... dilloWeight dillo
-- runOverDillo dillo = MkDillo Dead (dilloWeight dillo)
-- runOverDillo dillo = dillo { dilloLiveness = Dead } -- functional update
-- runOverDillo (MkDillo { dilloLiveness = l, dilloWeight = w}) =
--    MkDillo Dead w
runOverDillo (MkDillo _ w) = MkDillo Dead w

-- >>> runOverDillo dillo1
-- MkDillo {dilloLiveness = Dead, dilloWeight = 10}
