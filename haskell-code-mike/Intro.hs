module Intro where

import Prelude hiding (Monoid, Semigroup, Functor)

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

{-
-- Typklasse, denkt "Interface"
class Eq a where
    (==) :: a -> a -> Bool
-}

-- Instanz, denkt "Implementierung"
instance Eq Pet where
  (==) Dog Dog = True 
  (==) Cat Cat = True 
  (==) Snake Snake = True 
  (==) _ _ = False    

-- Ist ein Haustier niedlich?
isCute :: Pet -> Bool 
isCute Dog = True
isCute Cat = True
isCute Snake = False

-- Ein Gürteltier hat folgende Eigenschaften:
-- - tot oder lebendig
-- - Gewicht
data Liveness = Dead | Alive
  deriving (Show, Eq)

-- Typalias
type Weight = Integer

{-
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

-}
-- Ein Tier ist eins der folgenden:
-- - Gürteltier
-- - Papagei

data Animal = 
    MkDillo { dilloLiveness :: Liveness,
              dilloWeight :: Weight
    }
  | MkParrot String Weight
  deriving Show

dillo1 :: Animal
dillo1 = MkDillo Alive 10
dillo2 :: Animal
dillo2 = MkDillo Dead 8
parrot1 :: Animal
parrot1 = MkParrot "Hello!" 1
parrot2 :: Animal
parrot2 = MkParrot "Goodbye!" 2

runOverAnimal :: Animal -> Animal
runOverAnimal (MkDillo _ w) = MkDillo Dead w
runOverAnimal (MkParrot _ w) = MkParrot "" w

-- >>> runOverAnimal dillo1
-- MkDillo {dilloLiveness = Dead, dilloWeight = 10}

-- >>> runOverAnimal parrot1
-- MkParrot "" 1

-- nur einstellige Funktionen!
feedAnimal :: Animal -> (Weight -> Animal)
-- Alias-Pattern:
feedAnimal dillo@(MkDillo liveness weight) amount =
    case liveness of
        Dead -> dillo
        Alive -> MkDillo liveness (weight + amount)
-- feedAnimal (MkDillo Alive weight) amount = MkDillo Alive (weight + amount)
-- feedAnimal dillo@(MkDillo Dead weight) _ = dillo
feedAnimal (MkParrot sentence weight) amount = MkParrot sentence (weight + amount)

-- >>> feedAnimal dillo1 5
-- MkDillo {dilloLiveness = Alive, dilloWeight = 15}

{-
feedAnimal' :: Weight -> Animal -> Animal
feedAnimal' amount (MkDillo liveness weight)  = MkDillo liveness (weight + amount)
feedAnimal' amount (MkParrot sentence weight) = MkParrot sentence (weight + amount)
-}

-- feedAnimal' amount animal = feedAnimal animal amount

-- Typvariablen: Kleinschreibung
swap :: (a -> b -> c) -> (b -> a -> c)
swap f b a = f a b

feedAnimal' = swap feedAnimal

feedAnimal'' :: (Animal, Weight) -> Animal
feedAnimal'' (dillo@(MkDillo liveness weight), amount) =
    case liveness of
        Dead -> dillo
        Alive -> MkDillo liveness (weight + amount)
feedAnimal'' (MkParrot sentence weight, amount) =
    MkParrot sentence (weight + amount)

-- Moses Schönfinkel
-- Haskell Curry

entschönfinkeln :: (a -> b -> c) -> ((a, b) -> c)
-- tuplify f (a, b) = f a b
entschönfinkeln f = \ (a, b) -> f a b

schönfinkeln :: ((a, b) -> c) -> (a -> b -> c)
-- untuplify f = \ a -> \ b -> f (a, b)
schönfinkeln f a b = f (a, b)




-- f n = n + 1
f' = \ n -> n + 1

-- x = \ a -> \ b -> ... -> r
-- ==
-- x a b ... = r

-- Eta-Expansion:
-- (\ a -> r) a  ==  r

g x = let y = x + 1
      in y * y

-- Eine geometrische Figur ("shape") ist eins der folgenden:
-- - ein Kreis
-- - ein Quadrat
-- - die Überlagerung zweier geometrischer Figuren
-- 1. Datenanalyse + Code
-- 2. Schreibe eine Funktion, die für einen Punkt ermittelt, ob dieser
--    innerhalb oder außerhalb der geometrischen Figur liegt.

-- Transitivität
-- a R b /\ b R c => a R c

-- Funktionskomposition
o :: (b -> c) -> (a -> b) -> (a -> c)
o f g = \ a -> f (g a)

{-
data ListOfIntegers =
    Empty
  | Cons Integer ListOfIntegers
  deriving Show
-}

{-
data ListOf a =
    Empty
  | Cons a (ListOf a)
  deriving Show

-- Schablone
-- listSum Empty = undefined
-- listSum (Cons first rest) = first ... (listSum rest)

listSum :: ListOf Integer -> Integer
listSum Empty = 0
listSum (Cons first rest) = first + (listSum rest)
-}

-- leere Liste: []

-- >>> 1 : (2 : (3 : []))
-- [1,2,3]

-- >>> listSum [1,2,3,4,5]
-- 15
listSum :: [Integer] -> Integer
listSum [] = 0
listSum (first:rest) = first + (listSum rest)

type List a = [a]

listMap :: (a -> b) -> List a -> List b
listMap f [] = []
listMap f (x:xs) = (f x) : (listMap f xs) 

data Optional a =
    Absent
  | Present a
  deriving Show

optionalMap :: (a -> b) -> Optional a -> Optional b
optionalMap f Absent = Absent
optionalMap f (Present a) = Present (f a)

class Functor m where
    mmap :: (a -> b) -> m a -> m b

instance Functor Optional where
    mmap = optionalMap

instance Functor [] where
    mmap = listMap

-- =>: Implikation geht in die andere Richtung
instance Eq a => Eq (Optional a) where
    Absent == Absent = True 
    (Present x) == (Present y) = x == y
    _ == _ = False

-- >>> :type (==)
-- (==) :: Eq a => a -> a -> Bool

-- Eq a: Constraint
-- "Eq a =>": a muß ein Typ sein, der die Gleichheit unterstützt

-- Index eines Elements in einer Liste berechnen
listIndex :: Eq a => a -> [a] -> Optional Integer
listIndex a [] = Absent
listIndex a (x:xs) = 
    if a == x
    then Present 0
    else optionalMap (1 + ) (listIndex a xs)
{-              
         case listIndex a xs of
            Absent -> Absent
            Present index -> Present (index + 1)
-}
-- >>> listIndex 5 [1,2,3]
-- Absent

-- >>> listIndex 5 [1,2,3,4,5,6]
-- Present 4

{-
data Maybe a = Nothing | Just a
-}

-- sinnvolle Typklassen: universelle Abstraktionen, domänenunabhängig, Mathematik


-- Halbgruppe:
-- - Typ a
-- - op :: a -> a -> a
-- Assoziativgesetz
class Semigroup a where
    -- Assoziativität
    -- op a (op b c) == op (op a b) c
    op :: a -> a -> a

instance Semigroup [a] where
    op list1 list2 = list1 ++ list2

class Semigroup a => Monoid a where
    -- op neutral x == op x neutral == x
    neutral :: a

instance Monoid [a] where
    neutral = []

-- Instanzen für Monoid (Optional a)
--           und Monoid (a, b)

instance Semigroup a => Semigroup (Optional a) where
    op Absent Absent = Absent 
    op Absent (Present x) = Present x 
    op (Present x) Absent = Present x 
    op (Present x) (Present y) = Present (op x y)

instance Semigroup a => Monoid (Optional a) where
    neutral = Absent