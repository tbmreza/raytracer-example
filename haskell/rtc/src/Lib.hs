-- module Lib
--     ( someFunc
--     ) where

module Lib where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

data Tuple = Tuple  Float Float Float Float
        deriving Show

tupleX (Tuple x _ _ _) = x
tupleY (Tuple _ y _ _) = y
tupleZ (Tuple _ _ z _) = z
tupleW (Tuple _ _ _ w) = w

point :: Float -> Float -> Float -> Tuple
point x y z = Tuple x y z 1.0

vec :: Float -> Float -> Float -> Tuple
vec x y z = Tuple x y z 0.0

isPoint :: Tuple -> Bool
isPoint (Tuple _ _ _ 1.0) = True
isPoint _ = False

isVec :: Tuple -> Bool
isVec (Tuple _ _ _ 0.0) = True
isVec _ = False

(+) :: Tuple -> Tuple -> Tuple
(+) a b = (Tuple x y z w) where
        x = tupleX a Prelude.+ tupleX b
        y = tupleY a Prelude.+ tupleY b
        z = tupleZ a Prelude.+ tupleZ b
        w = tupleW a Prelude.+ tupleW b


(-) :: Tuple -> Tuple -> Tuple
(-) a b = (Tuple x y z w) where
        x = tupleX a Prelude.- tupleX b
        y = tupleY a Prelude.- tupleY b
        z = tupleZ a Prelude.- tupleZ b
        w = tupleW a Prelude.- tupleW b


-- Scenario: A tuple with w=1.0 is a point  ?? hspec
t1 = isPoint (Tuple 4.3 (-4.2) 3.1 1.0)
t2 = isVec (Tuple 4.3 (-4.2) 3.1 1.0)

-- Scenario: A tuple with w=0 is a vector
t3 = isPoint (Tuple 4.3 (-4.2) 3.1 0.0)
t4 = isVec (Tuple 4.3 (-4.2) 3.1 0.0)

-- Scenario: Adding two tuples
t5 = (Tuple 3 (-2) 5 1) Lib.+ (Tuple (-2) 3 1 0)  -- (Tuple 1 1 6 1)

-- Scenario: Subtracting two points
t6 = (point 3 2 1) Lib.- (point 5 6 7)  -- Tuple (-2.0) (-4.0) (-6.0) 0.0
