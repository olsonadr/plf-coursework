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
type Gate = (Int, GateFN)
data GateFN = AND | OR | XOR | NOT deriving Show
type Link = ((Int, Int), (Int, Int))
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

-- dlStr function: digital logic circuit toString method --
dlStr :: Circuit -> String
dlStr _ = "wow"

-- dlPP function: pretty printer for digital logic circuits --
dlPP :: Circuit -> IO()
dlPP C = putStrLn (dlToString C)



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