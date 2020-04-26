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


-- == For MiniLogo == --

-- cmd      ::= pen 'mode'
--           |  moveto ('pos','pos')
--           |  def 'name' ( 'pars' ) 'cmd'
--           |  call 'name' ( 'vals' )
--           |  'cmd'; 'cmd'
-- mode     ::= up | down
-- pos      ::= 'num' | 'name'
-- pars     ::= 'name', 'pars' | 'name'
-- vals     ::= 'num', 'vals' | 'num'

data Cmd    = Pen     Mode               -- change pen mode (up or down)
            | MoveTo  Pos Pos            -- move pen to given position
            | Def     String Params Cmd  -- def macro with name, params, body
            | Call    String Args        -- call macro of name, arg values
            | SeqC    Cmd Cmd            -- allow chaining of commands
data Mode   = Up | Down                  -- allowed pen modes
data Pos    = Num Integer                -- allowing numerical positions      
            | Var String                 -- allowing variable names
data Params = SeqP String Params         -- allowing chaining of multiple params
            | OneP String                -- enforcing at least one (not a list)
data Args   = SeqA Integer Args          -- allowing chaining of multiple args
            | OneA Integer               -- enforcing at least one (not a list)

-- Show functions to check if correctly matching the concrete syntax --
instance Show Params where  
    show (SeqP s ps)    = s ++ ", " ++ show ps
    show (OneP s)       = s
    
instance Show Args where  
    show (SeqA i as)    = show i ++ ", " ++ show as
    show (OneA i)       = show i

instance Show Cmd where
    show (Pen m)        = "pen " ++ show m ++ ""
    show (MoveTo a b)   = "moveto (" ++ show a ++ "," ++ show b ++ ")"
    show (Def n p c)    = "def " ++ n ++ " ( " ++ show p ++ " ) " ++ show c
    show (Call n a)     = "call " ++ n ++ "( " ++ show a ++ " ) "
    show (SeqC c1 c2)   = show c1 ++ "; " ++ show c2

instance Show Pos where
    show (Num i)    = show i
    show (Var s)    = s

instance Show Mode where
    show Up     = "up"
    show Down   = "down"



-- ====================================== --
-- ========== Creating Examples ========= --
-- ====================================== --

-- == For DigitalCircuits == --

-- half adder: (1:xor; 2:and; from 1.1 to 2.1; from 1.2 to 2.2;)
ha_correct = "1:xor;\n2:and;\nfrom 1.1 to 2.1;\nfrom 1.2 to 2.2;"
ha = ([(1, XOR),(2, AND)], [((1,1),(2,1)), ((1,2),(2,2))])


-- == For MiniLogo == --

-- vector macro: draws line from position (x1,y1) to position (x2,y2)

-- in MiniLogo:
vector_correct = "def vector ( x1, y1, x2, y2 ) pen up; moveto (x1,y1); pen down; moveto (x2,y2); pen up"

-- in Abstract Syntax (haskell data types):
-- v_name = "vector"
-- v_par  = (SeqP "x1" (SeqP "y1" (SeqP "x2" (OneP "y2")))) :: Params
-- v_cmd  = (SeqC (Pen Up) (SeqC (MoveTo (Var "x1") (Var "y1")) (SeqC (Pen Down) (SeqC (MoveTo (Var "x2") (Var "y2")) (Pen Up))))) :: Cmd
-- vector = (Def (v_name)    -- macro name
--               (v_par)     -- macro parameters
--               (v_cmd)     -- macro commands
--          ) :: Cmd
vector = (Def ("vector")                                        -- macro name
              (SeqP "x1" (SeqP "y1" (SeqP "x2" (OneP "y2"))))   -- macro parameters
              (SeqC (Pen Up)                                    -- start macro commands
                    (SeqC (MoveTo (Var "x1") (Var "y1"))
                          (SeqC (Pen Down)
                                (SeqC (MoveTo (Var "x2") (Var "y2"))
                                      (Pen Up)))))              -- end macro commands
         ) :: Cmd



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


-- == For MiniLogo == --

-- createStepMacro function: creates def for macro that draws one step --
-- def drawpath ( x1, y1, x2, y2, x3, y3 ) from a starting point, draw a path including second point to third
createStepMacro :: Cmd
createStepMacro = (Def ("drawpath")                                                               -- macro name
                       (SeqP "x1" (SeqP "y1" (SeqP "x2" (SeqP "y2" (SeqP "x3"  (OneP "y3"))))))   -- macro parameters
                       (SeqC (Pen Up)                                                             -- start macro commands
                             (SeqC (MoveTo (Var "x1") (Var "y1"))
                                   (SeqC (Pen Down)
                                         (SeqC (MoveTo (Var "x2") (Var "y2"))
                                               (SeqC (MoveTo (Var "x3") (Var "y3"))
                                                     (Pen Up))))))                                -- end macro commands
                   ) :: Cmd

-- createStepCalls function: creates N calls of one step macro --
createStepCalls :: Integer -> Cmd
createStepCalls n | n <= 0    = Pen Up
                  | n == 1    = (Call "drawpath" (SeqA n (SeqA n (SeqA (n-1) (SeqA n (SeqA (n-1) (OneA (n-1))))))))
                  | otherwise = (SeqC (Call "drawpath" (SeqA n (SeqA n (SeqA (n-1) (SeqA n (SeqA (n-1) (OneA (n-1)))))))) (createStepCalls (n-1)))

-- programToString function: formats a command with newlines (as in a program) --
programToString :: Cmd -> String 
programToString (Pen m)        = "pen " ++ show m ++ "\n"
programToString (MoveTo a b)   = "moveto (" ++ show a ++ "," ++ show b ++ ")\n"
programToString (Def n p c)    = "def " ++ n ++ " ( " ++ show p ++ " ) " ++ show c ++ "\n"
programToString (Call n a)     = "call " ++ n ++ "( " ++ show a ++ " )\n"
programToString (SeqC c1 c2)   = programToString c1 ++ programToString c2

-- programPP function: pretty prints a command that is a program with newlines --
programPP :: Cmd -> IO ()
programPP c = putStrLn (programToString c)

-- steps function: creates MiniLogo program that draws stairs of n steps --
steps :: Int -> Cmd
steps n = (SeqC createStepMacro (createStepCalls (toInteger n)))



-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- DigitalCircuit test function
dl_test = do
    putStrLn "\n~= Testing DigitalCircuits questions:\n"
    putStrLn ("~= half adder circuit should be:\n" ++ ha_correct ++ "\n\n~= and is (defined on line 30):\n" ++ (dlStr ha))
    putStrLn "~= End DigitalCircuits testing\n"

-- MiniLogo test function
ml_test = do
    putStrLn "\n~= Testing MiniLogo questions:\n"
    putStrLn ("~= vector macro should be:\n" ++ vector_correct ++ "\n\n~= and is (defined on line 84):\n" ++ show vector ++ "\n\n")
    putStrLn ("~= (steps 2) program (pretty printed):")
    programPP (steps 2)
    putStrLn ("\n~= (steps 4) program (pretty printed):")
    programPP (steps 4)
    putStrLn "\n~= End MiniLogo testing\n"

-- Help function
help = do
    putStrLn "\nHW2 Loading! Functions:"
    putStrLn " ~= help      : re-display this message"
    putStrLn " ~= dl_test   : test DigitalCircuits functions"
    putStrLn " ~= ml_test   : test MiniLogo functions"
    putStrLn " ~= dlPP      : pretty printing for a Circuit (matching concrete syntax)"
    putStrLn " ~= oldDLPP   : alternative pretty printing format for a Circuit"
    putStrLn " ~= programPP : pretty printing a MiniLogo \"program\" (sequence of commands) with newlines"
    putStrLn " "

-- Main function (help)
main = help
