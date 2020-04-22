module HW2 where


-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

-- == For DigitalCircuits == --

-- circuit  ::= gates links
-- gates    ::= num:gateFn ; gates | ϵ
-- gateFn   ::= and | or | xor | not
-- links    ::= from num.num to num.num; links | ϵ

type Circuit = ([Gate], [Link])
type Gate = (Integer, GateFN)
data GateFN = AND | OR | XOR | NOT deriving Show
type Link = ((Integer, Integer), (Integer, Integer))
-- Link = ((Gate_Idx_1, IO_Idx_1), (Gate_Idx_2, IO_Idx_2)



-- ====================================== --
-- ========== Creating Examples ========= --
-- ====================================== --

-- == For DigitalCircuits == --

-- half adder: (1:xor; 2:and; from 1.1 to 2.1; from 1.2 to 2.2;)
ha = ([(1, XOR),(2, AND)], [((1,1),(2,1)), ((1,2),(2,2))])



-- ====================================== --
-- ======== Function Defintions ========= --
-- ====================================== --

-- == For DigitalCircuits == --

-- linkStr function: single Link toString method --
linkStr :: Link -> String
linkStr ((g1, i1), (g2, i2)) = "\t\tGate"++show g1++" [" ++ show i1 ++ "]\t->\t Gate"++show g2++" [" ++ show i2 ++ "]\n"

-- gateStr function: single Gate toString method --
gateStr :: Gate -> String
gateStr (i, fn)     = "\t\tGate" ++ show i ++ " is " ++ show fn ++ "\n"

-- _dlStr function: actual digital logic circuit toString method --
_dlStr :: Circuit -> String
_dlStr ((g:[]), ls)  = (gateStr g) ++ "\n~= Links between gates:\n" ++ (_dlStr ([], ls))
_dlStr ((g:gs), ls)  = (gateStr g) ++ (_dlStr (gs, ls))
_dlStr ([], (l:ls))  = (linkStr l) ++ (_dlStr ([], ls))
_dlStr ([], [])      = "\n"

-- dlStr function: digital logic circuit toString wrapper for adding header --
dlStr :: Circuit -> String
dlStr c = "\n~= Gates in digital circuit:\n" ++ (_dlStr c)


-- dlPP function: pretty printer for digital logic circuits --
dlPP :: Circuit -> IO()
dlPP c = putStrLn (dlStr c)



-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- Main function (help)
main = do
    putStrLn "HW2 Loading! Available helper functions:"
    --putStrLn " ~= bg_test  :  test Bag functions"
    --putStrLn " ~= gr_test  :  test Graph functions"
    --putStrLn " ~= sh_test  :  test Shape functions"
    putStrLn " "