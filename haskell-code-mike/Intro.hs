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

o :: (b -> c) -> (a -> b) -> (a -> c)
o f g = \ a -> f (g a)
