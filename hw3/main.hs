module HW3 where


-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

-- == For StackLanguage == --

-- S ::= C | C;S
-- C ::= LD Int | ADD | MULT | DUP

type Prog   = [Cmd]
data Cmd    = LD Int
            | ADD
            | MULT
            | DUP deriving Show
type Stack = [Int]

type StackState = Maybe Stack
type D = StackState -> StackState



-- ====================================== --
-- ============ Test Examples =========== --
-- ====================================== --

-- == For StackLanguage == --

slP1 = [LD 3,DUP,ADD,DUP,MULT] :: Prog
slP2 = [LD 3,ADD] :: Prog
slP3 = [] :: Prog



-- ====================================== --
-- ======== Function Defintions ========= --
-- ====================================== --

-- == For StackLanguage == --

-- sem: semantic function for a full program --
sem :: Prog -> D
sem pr st = st

-- semCmd: semantic function for a single command in a program --
semCmd :: Cmd -> D
semCmd cmd st = st



-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- StackLanguage test function
sl_test = do
    putStrLn "\n~= Testing StackLanguage questions:\n"
    putStrLn "~= semantic results of example programs on empty starting stacks:\n"
    putStrLn ("   sem (" ++ show slP1 ++ ") [] = " ++ show (sem slP1 (Just [])) ++ "")
    putStrLn ("   sem (" ++ show slP2 ++ ") [] = " ++ show (sem slP2 (Just [])) ++ "")
    putStrLn ("   sem (" ++ show slP3 ++ ") [] = " ++ show (sem slP3 (Just [])) ++ "")
    putStrLn "~= End StackLanguage testing\n"

-- Help function
help = do
    putStrLn "\nHW3 Loading! Functions:"
    putStrLn " ~= help      : re-display this message"
    putStrLn " ~= sl_test   : test StackLanguage functions"
    putStrLn " "

-- Main function (help)
main = help
