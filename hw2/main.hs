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


data Cmd    = Pen     Mode                  -- change pen mode (up or down)
            | MoveTo  Pos Pos               -- move pen to given position
            | Def     String Params Cmd     -- define macro with name, parameters, and body
            | Call    String Args           -- call macro with given name, passing in values
            | SeqC    Cmd Cmd               -- allow chaining of commands

data Mode   = Up | Down                     -- allowed pen modes

data Pos    = Num Integer                   -- allowing numerical positions      
            | Var String                    -- allowing variable names

data Params = SeqP String Params            -- allowing chaining of multiple params
            | OneP String                   -- enforcing at least one (not a list)

data Args   = SeqA Integer Args             -- allowing chaining of multiple args
            | OneA Integer                  -- enforcing at least one (not a list)


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

-- steps function: creates MiniLogo program that draws stairs of n steps --
steps :: Int -> Cmd
steps _ = Pen Up; -- placeholder --



-- ====================================== --
-- ========== Helper Functions ========== --
-- ====================================== --

-- Main function (on load)
main = do
    putStrLn "HW2 Loading! Available helper functions:"
    --putStrLn " ~= bg_test  :  test Bag functions"
    --putStrLn " ~= gr_test  :  test Graph functions"
    --putStrLn " ~= sh_test  :  test Shape functions"
    putStrLn " "