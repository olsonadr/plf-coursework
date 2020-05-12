module HW4 where

import Data.List (sort,nub)

-- ====================================== --
-- ============= Exercise 1 ============= --
-- ====================================== --

-- == Preliminary Definitions == --

-- S ::= C | C;S
-- C ::= LD Int | ADD | MULT | DUP | INC | SWAP | POP Int

type Prog   = [Cmd]
data Cmd    = LD Int
            | ADD
            | MULT
            | DUP
            | INC
            | SWAP
            | POP Int deriving Show
type Stack  = [Int]

type StackState = Maybe Stack
type D = StackState -> StackState

slP1 = [LD 3,DUP,ADD,DUP,MULT] :: Prog
slP2 = [LD 3,ADD] :: Prog
slP3 = [] :: Prog



-- == Part (a) == --

type Rank = Int
type CmdRank = (Int,Int)

-- rankC: returns the resultant rank for a command --
rankC :: Cmd -> CmdRank
rankC (LD _)    = (0,1)
rankC (ADD)     = (2,1)
rankC (MULT)    = (2,1)
rankC (DUP)     = (1,2)
rankC (INC)     = (1,1)
rankC (SWAP)    = (2,2)
rankC (POP k)   = (k,0)

-- rank: recursively determine overall rank of program --
rank :: Prog -> Rank -> Maybe Rank
rank [] r       = Just r
rank (c:ls) r   | i > r     = Nothing
                | otherwise = rank ls (r + j - i)
                    where (i,j) = rankC c

-- rankP: determine the rank of a program --
rankP :: Prog -> Maybe Rank
rankP [] = Just 0
rankP pr = rank pr 0



-- == Part (b) == --

-- sem: semantic function for a full program --
sem :: Prog -> D
sem _ (Nothing)         = Nothing
sem [] (Just st)        = (Just st)
sem (c:ps) (Just st)    = sem ps (semCmd c (Just st))

-- semCmd: semantic function for a single command in a program --
semCmd :: Cmd -> D
semCmd (LD i) (Just st) = (Just (i:st))
semCmd (ADD)  (Just st) = case st of
                                (i1:(i2:ls)) -> (Just ((i1+i2):ls))
                                _            -> Nothing
semCmd (MULT) (Just st) = case st of
                                (i1:(i2:ls)) -> (Just ((i1*i2):ls))
                                _            -> Nothing
semCmd (DUP)  (Just st) = case st of
                                (i1:ls) -> (Just (i1:(i1:ls)))
                                _       -> Nothing
semCmd _ _              = Nothing

-- semStatTC: semantic function with initial typecheck
semStatTC :: Prog -> D
semStatTC pr st |  rankP pr == Nothing  = Nothing
                |  otherwise            = sem pr st






-- ====================================== --
-- ============= Exercise 2 ============= --
-- ====================================== --

-- == Preliminary Definitions == --

-- Syntax of shapes--
data Shape  = X
            | TD Shape Shape
            | LR Shape Shape
            deriving Show

-- Semantic domain: an image is a set of pixels--
type Pixel = (Int,Int)
type Image = [Pixel]

-- Type: bounding box of the shape (width,height)
type BBox = (Int,Int)

-- Semantic function--
semSh :: Shape -> Image
semSh X           = [(1,1)]
semSh (LR s1 s2)  = d1 ++ [(x+maxx d1,y)
                | (x,y) <- semSh s2]
                    where d1 = semSh s1
semSh (TD s1 s2)  = d2 ++ [(x,y+maxy d2)
                | (x,y) <- semSh s1]
                    where d2 = semSh s2

maxx :: [Pixel] -> Int
maxx = maximum . map fst

maxy :: [Pixel] -> Int
maxy = maximum . map snd

-- Examples--
s1 = LR (TD X X) X
p1 = semSh s1
s2 = TD X (LR X X)
p2 = semSh s2
s3 = TD (LR X X) X
p3 = semSh s3
s4 = TD (TD (LR X X) X) X
p4 = semSh s4
s5 = LR (TD X X) (TD X X)
p5 = semSh s5


-- == Part (a) == --

minx :: [Pixel] -> Int
minx = minimum . map fst

miny :: [Pixel] -> Int
miny = minimum . map snd

bbox :: Shape -> BBox
bbox sh = ((maxx i)-(minx i)+1,(maxy i)-(miny i)+1)
            where i = semSh sh



-- == Part (b) == --

getXCount :: Int -> (Image -> Int)
getXCount x = (length . filter (==x) . map fst)

-- checkRect: checks if Image has correct count in each column --
--           image    height currX  result
checkRect :: Image -> Int -> Int -> Bool
checkRect _ _ x | x == 0             = True
checkRect i h x | getXCount x i == h = checkRect i h (x-1)
                | otherwise          = False
                
-- rect: typechecker that only assigns types to rectangular shapes --
rect :: Shape -> Maybe BBox
rect sh | checkRect i h w   = Just (w,h)
        | otherwise         = Nothing
            where i     = semSh sh
                  (w,h) = bbox sh






-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- StackLanguage test function
sl2_test = do
    putStrLn "\n~= Testing exercise 1:\n"
    putStrLn "~= semantic results of example programs on empty starting stacks:\n"
    putStrLn ("   semStatTC (" ++ show slP1 ++ ") [] = " ++ show (semStatTC slP1 (Just [])) ++ "")
    putStrLn ("   semStatTC (" ++ show slP2 ++ ") [] = " ++ show (semStatTC slP2 (Just [])) ++ "")
    putStrLn ("   semStatTC (" ++ show slP3 ++ ") [] = " ++ show (semStatTC slP3 (Just [])) ++ "")
    putStrLn "\n~= End exercise 1 testing\n"

-- ShapeTypes test function
sh2_test = do
    putStrLn "\n~= Testing exercise 2:\n"
    putStrLn "~= bbox results of example shapes:\n"
    putStrLn ("   bbox (" ++ show s1 ++ ") = " ++ show (bbox s1) ++ "")
    putStrLn ("   bbox (" ++ show s3 ++ ") = " ++ show (bbox s3) ++ "")
    putStrLn ("   bbox (" ++ show s5 ++ ") = " ++ show (bbox s5) ++ "")
    putStrLn "\n~= rect results of example shapes:\n"
    putStrLn ("   rect (" ++ show s1 ++ ") = " ++ show (rect s1) ++ "")
    putStrLn ("   rect (" ++ show s3 ++ ") = " ++ show (rect s3) ++ "")
    putStrLn ("   rect (" ++ show s5 ++ ") = " ++ show (rect s5) ++ "")
    putStrLn "\n~= End exercise 2 testing\n"

-- Help function
help = do
    putStrLn "\nHW4 Loading! Functions:"
    putStrLn " ~= help      : re-display this message"
    putStrLn " ~= sl2_test  : test StackLanguage2 functions (exercise 1)"
    putStrLn " ~= sh2_test  : test ShapeType functions (exercise 2)"
    putStrLn " "

-- Main function (help)
main = help
