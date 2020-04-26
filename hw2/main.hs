module HW2 where


-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

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

-- == For MiniLogo == --

-- vector macro: draws line from position (x1,y1) to position (x2,y2)

-- in MiniLogo:
vector_correct = "def vector ( x1, y1, x2, y2 ) pen up; moveto (x1,y1); pen down; moveto (x2,y2); pen up"

-- in Abstract Syntax (haskell data types):
--v_name = "vector"
--v_par = (SeqP "x1" (SeqP "y1" (SeqP "x2" (OneP "y2")))) :: Params
--v_cmd = (SeqC (Pen Up) (SeqC (MoveTo (Var "x1") (Var "y1")) (SeqC (Pen Down) (SeqC (MoveTo (Var "x2") (Var "y2")) (Pen Up))))) :: Cmd
--vector = (Def (v_name)    -- macro name
--              (v_par)     -- macro parameters
--              (v_cmd)     -- macro commands
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

-- == For MiniLogo == --

-- cant use these but I wish we could (no addition defined in MiniLogo)
-- -- createStepMacro function: creates def for macro that draws one step
-- -- createStepCalls function: creates N calls of one step macro
-- end of what we cant use
 

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


--call = (Call "drawpath" (SeqA n (SeqA n (SeqA (n-1) (SeqA n (SeqA (n-1) (OneA (n-1))))))) :: Cmd

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

-- MiniLogo testing
ml_test = do
    putStrLn "\n~= Testing MiniLogo questions:\n"
    putStrLn ("~= vector macro should be:\n" ++ vector_correct ++ "\n\n~= and is (defined on line 84):\n" ++ show vector ++ "\n\n")
    putStrLn ("~= (steps 2) program (pretty printed):")
    programPP (steps 2)
    putStrLn ("\n~= (steps 4) program (pretty printed):")
    programPP (steps 4)
    putStrLn "\n~= End MiniLogo testing\n"


-- Main function (on load)
main = do
    putStrLn "HW2 Loading! Usage:"
    putStrLn " ~= ml_test   :  test MiniLogo functions"
    putStrLn " ~= programPP :  function to pretty print a sequence of commands with newlines (i.e. programPP (Pen Up) )"
    --putStrLn " ~= gr_test  :  test Graph functions"
    --putStrLn " ~= sh_test  :  test Shape functions"
    putStrLn " "