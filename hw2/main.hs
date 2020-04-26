module HW2 where


-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

-- == For DigitalCircuits == --

-- circuit  ::= gates links
-- gates    ::= num:gateFn ; gates | ϵ
-- gateFn   ::= and | or | xor | not
-- links    ::= from num.num to num.num; links | ϵ

type Circuit    = ([Gate], [Link])
type Gate       = (Integer, GateFN)
data GateFN     = AND | OR | XOR | NOT deriving Show
type Link       = ((Integer, Integer), (Integer, Integer))
-- Link = ((Gate_Idx_1, IO_Idx_1), (Gate_Idx_2, IO_Idx_2)



-- ====================================== --
-- ========== Creating Examples ========= --
-- ====================================== --

-- == For DigitalCircuits == --

-- half adder: (1:xor; 2:and; from 1.1 to 2.1; from 1.2 to 2.2;)
ha_correct = "1:xor;\n2:and;\nfrom 1.1 to 2.1;\nfrom 1.2 to 2.2;"
ha = ([(1, XOR),(2, AND)], [((1,1),(2,1)), ((1,2),(2,2))])



-- ====================================== --
-- ======== Function Defintions ========= --
-- ====================================== --

-- == For DigitalCircuits == --

-- -- start of new pretty printing methods -- --
-- fnStr function: GateFN toString method --
fnStr :: GateFN -> String
fnStr AND    = "and"
fnStr OR     = "or"
fnStr XOR    = "xor"
fnStr NOT    = "not"

-- linkStr function: single Link toString method --
linkStr :: Link -> String
linkStr ((g1, i1), (g2, i2)) =   "from " ++ show g1 ++ "." ++ show i1 ++ " to " ++ show g2 ++ "." ++ show i2 ++ ";\n"

-- gateStr function: single Gate toString method --
gateStr :: Gate -> String
gateStr (i, fn)     = show i ++ ":" ++ (fnStr fn) ++ ";\n"

-- dlStr function: digital logic circuit toString method --
dlStr :: Circuit -> String
dlStr ((g:gs), ls)  = (gateStr g) ++ (dlStr (gs, ls))
dlStr ([], (l:ls))  = (linkStr l) ++ (dlStr ([], ls))
dlStr ([], [])      = ""

-- dlPP function: pretty printer for digital logic circuits --
dlPP :: Circuit -> IO()
dlPP c = putStrLn ("\n" ++ dlStr c)
-- -- end of new pretty printing methods -- --


-- -- start of old pretty printing methods -- --
-- oldLinkStr function: single Link toString method --
oldLinkStr :: Link -> String
oldLinkStr ((g1, i1), (g2, i2)) = "\t\tGate"++show g1++" [" ++ show i1 ++ "]\t->\t Gate"++show g2++" [" ++ show i2 ++ "]\n"

-- oldGateStr function: single Gate toString method --
oldGateStr :: Gate -> String
oldGateStr (i, fn)     = "\t\tGate" ++ show i ++ " is " ++ show fn ++ "\n"

-- _oldDLStr function: actual digital logic circuit toString method --
_oldDLStr :: Circuit -> String
_oldDLStr ((g:[]), ls)  = (oldGateStr g) ++ "\n~= Links between gates:\n" ++ (_oldDLStr ([], ls))
_oldDLStr ((g:gs), ls)  = (oldGateStr g) ++ (_oldDLStr (gs, ls))
_oldDLStr ([], (l:ls))  = (oldLinkStr l) ++ (_oldDLStr ([], ls))
_oldDLStr ([], [])      = ""

-- oldDLStr function: digital logic circuit toString wrapper for adding header --
oldDLStr :: Circuit -> String
oldDLStr c = "\n~= Gates in digital circuit:\n" ++ (_oldDLStr c)

-- oldDLPP function: pretty printer for digital logic circuits --
oldDLPP :: Circuit -> IO()
oldDLPP c = putStrLn (oldDLStr c)
-- -- end of old pretty printing methods -- --



-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- Digital Circuit test function
dl_test = do
    putStrLn "\n~= Testing DigitalCircuits questions:\n"
    putStrLn ("~= half adder circuit should be:\n" ++ ha_correct ++ "\n\n~= and is (defined on line 30):\n" ++ (dlStr ha))
    putStrLn "~= End DigitalCircuits testing\n"

-- Help function
help = do
    putStrLn "\nHW2 Loading! Functions:"
    putStrLn " ~= help     : redisplay this message"
    putStrLn " ~= dl_test  : test DigitalCircuits functions"
    putStrLn " ~= dlPP     : pretty printing for a Circuit (matching concrete syntax)"
    putStrLn " ~= oldDLPP  : alternative pretty printing format for a Circuit"
    putStrLn " "

-- Main function (help)
main = help