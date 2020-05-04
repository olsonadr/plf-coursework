module HW3 where

import System.IO
import SVG

-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

-- == For MiniLogo == --

data CmdML   = Pen Mode
             | MoveTo Int Int
             | Seq CmdML CmdML deriving Show
data Mode    = Up | Down deriving Show

type State   = (Mode, Int, Int)  -- mode and location of pen

type LineML  = (Int,Int,Int,Int) -- (x1,y1,x2,y2)
type LinesML = [LineML]



-- ====================================== --
-- ============ Test Examples =========== --
-- ====================================== --

-- == For MiniLogo == --

mlP1 = (MoveTo 0 0) `Seq` (Pen Down) `Seq` (MoveTo 0 3) :: CmdML -- draws a vertical line
mlP2 = (MoveTo 0 0) `Seq` (Pen Down) `Seq` (MoveTo 5 5) `Seq` (Pen Up) `Seq` (MoveTo 0 5) `Seq` (Pen Down) `Seq` (MoveTo 5 0) :: CmdML -- draws an X at the origin
mlP3 = (MoveTo 0 1) `Seq` (Pen Down) `Seq` (MoveTo 0 2) `Seq` (MoveTo 1 2) `Seq` (MoveTo 1 3) `Seq` (MoveTo 2 3) `Seq` (MoveTo 2 1) `Seq` (MoveTo 0 1) `Seq` (Pen Up) `Seq` (MoveTo 0 0) `Seq` (Pen Down) `Seq` (MoveTo 2 0) :: CmdML -- draws staircase with a line below



-- ====================================== --
-- ======== Function Defintions ========= --
-- ====================================== --

-- == For MiniLogo == --

-- semS: semantic function for ML commands w/ initial state --
semS :: CmdML -> State -> (State, LinesML)
semS (Pen m) (_,x,y)            = ((m,x,y),[])
semS (MoveTo x2 y2) (m,x1,y1)   = case m of
                                    Up   -> ((m,x2,y2),[])
                                    Down -> ((m,x2,y2),[(x1,y1,x2,y2)])
semS (Seq c1 c2) st1            = case (semS c1 st1) of
                                    (st2,ls1) -> (case (semS c2 st2) of
                                                    (st3,ls2) -> (st3,(ls1++ls2)))

-- sem': semantic function for ML commands w/o initial state --
sem' :: CmdML -> LinesML
sem' cmd = case (semS cmd (Up, 0, 0)) of
                (st, lns) -> lns



-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- MiniLogo test functions
ml_test = do
    putStrLn "\n~= Testing MiniLogo questions:\n"
    putStrLn "~= semantic results of example commands with default state:\n"
    putStrLn ("   sem' (" ++ show mlP1 ++ ") [] = " ++ show (sem' mlP1) ++ "")
    putStrLn ("   sem' (" ++ show mlP2 ++ ") [] = " ++ show (sem' mlP2) ++ "")
    putStrLn ("   sem' (" ++ show mlP3 ++ ") [] = " ++ show (sem' mlP3) ++ "")
    putStrLn "\n~= End MiniLogo testing\n"

ml_pp1 = do
    putStrLn "\n~= Pretty printing example mlP1 to MiniLogo.svg...\n"
    ppLines (sem' mlP1)
    putStrLn "    ppLines (sem' mlP1)"
    putStrLn "\n~= Done pretty printing mlP1\n"

ml_pp2 = do
    putStrLn "\n~= Pretty printing example mlP2 to MiniLogo.svg...\n"
    ppLines (sem' mlP2)
    putStrLn "    ppLines (sem' mlP2)"
    putStrLn "\n~= Done pretty printing mlP2\n"

ml_pp3 = do
    putStrLn "\n~= Pretty printing example mlP3 to MiniLogo.svg...\n"
    ppLines (sem' mlP3)
    putStrLn "    ppLines (sem' mlP3)"
    putStrLn "\n~= Done pretty printing mlP3\n"

-- Help function
help = do
    putStrLn "\nHW3 Loading! Functions:"
    putStrLn " ~= help      : re-display this message"
    putStrLn " ~= ml_test   : test MiniLogo functions"
    putStrLn " ~= ml_pp1    : pretty print mlP1 MiniLogo function using SVG"
    putStrLn " ~= ml_pp2    : pretty print mlP1 MiniLogo function using SVG"
    putStrLn " ~= ml_pp3    : pretty print mlP1 MiniLogo function using SVG"
    putStrLn " "

-- Main function (help)
main = help
