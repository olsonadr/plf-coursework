module HW3 where


-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

-- == For MiniLogo == --

data CmdML  = Pen Mode
            | MoveTo Int Int
            | Seq CmdML CmdML deriving Show
data Mode   = Up | Down deriving Show

type State  = (Mode, Int, Int) -- mode and location of pen

type Line   = (Int,Int,Int,Int)
type Lines  = [Line]


-- ====================================== --
-- ============ Test Examples =========== --
-- ====================================== --

-- == For MiniLogo == --

mlP1 = (MoveTo 0 (-1)) `Seq` (Pen Down) `Seq` (MoveTo 0 1) :: CmdML -- draws a vertical line at the origin
mlP2 = (MoveTo (-1) (-1)) `Seq` (Pen Down) `Seq` (MoveTo 1 1) `Seq` (Pen Up) `Seq` (MoveTo (-1) 1) `Seq` (Pen Down) `Seq` (MoveTo 1 (-1)) :: CmdML -- draws an X at the origin
mlP3 = (Pen Down) `Seq` (MoveTo 0 1) `Seq` (MoveTo 1 1) `Seq` (MoveTo 1 2) `Seq` (MoveTo 2 2) `Seq` (MoveTo 2 0) `Seq` (MoveTo 0 0) `Seq` (Pen Up) `Seq` (MoveTo 0 (-1)) `Seq` (MoveTo 1 (-1)) :: CmdML -- draws staircase with a line below



-- ====================================== --
-- ======== Function Defintions ========= --
-- ====================================== --

-- == For MiniLogo == --

-- semS: semantic function for ML commands w/ initial state --
semS :: CmdML -> State -> (State, Lines)
semS cmd st = (st, [])

-- sem': semantic function for ML commands w/o initial state --
sem' :: CmdML -> Lines
sem' cmd = case (semS cmd (Up, 0, 0)) of
                (st, lns) -> lns



-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- MiniLogo test function
ml_test = do
    putStrLn "\n~= Testing MiniLogo questions:\n"
    putStrLn "~= semantic results of example commands with default state:\n"
    putStrLn ("   sem' (" ++ show mlP1 ++ ") [] = " ++ show (sem' mlP1) ++ "")
    putStrLn ("   sem' (" ++ show mlP2 ++ ") [] = " ++ show (sem' mlP2) ++ "")
    putStrLn ("   sem' (" ++ show mlP3 ++ ") [] = " ++ show (sem' mlP3) ++ "")
    putStrLn "~= the results should also be pretty printed in SVG files"
    putStrLn "\n~= End MiniLogo testing\n"

-- Help function
help = do
    putStrLn "\nHW3 Loading! Functions:"
    putStrLn " ~= help      : re-display this message"
    putStrLn " ~= sl_test   : test StackLanguage functions"
    putStrLn " ~= ml_test   : test MiniLogo functions"
    putStrLn " "

-- Main function (help)
main = help
