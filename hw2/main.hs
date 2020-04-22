module HW2 where


-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

-- == For MiniLogo == --

-- cmd      ::= pen mode
--           |  moveto (pos,pos)
--           |  def name ( pars ) cmd
--           |  call name ( vals )
--           |  cmd; cmd
-- mode     ::= up | down
-- pos      ::= num | name
-- pars     ::= name, pars | name
-- vals     ::= num, vals | num

data Cmd    = Pen     Mode                  -- change pen mode (up or down)
            | MoveTo  Pos                   -- move pen to given position
            | Def     String [String] [Cmd] -- define macro with name, parameters, and body
            | Call    String [Integer]      -- call macro with given name, passing in values
            deriving Show
data Mode   = Up | Down                     -- allowed pen modes
            deriving Show
data Pos    = N (Integer, Integer)          -- allowing numerical positions
            | P (String, String)            -- allowing parameter names for positions

instance Show Pos where  
    show (N (n1, n2)) = show (n1, n2)  
    show (P (s1, s2)) = show (s1, s2)



-- ====================================== --
-- ========== Creating Examples ========= --
-- ====================================== --

-- == For MiniLogo == --

-- vector macro: draws line from position (x1,y1) to position (x2,y2)
-- in MiniLogo:
--     def vector ( x1, y1, x2, y2 ) pen up; moveto (x1,y1); pen down; moveto (x2,y2); pen up
-- in Abstract Syntax (haskell data types):
vector = Def "vector" ["x1", "y1", "x2", "y2"] [Pen Up, MoveTo (P ("x1", "y1")), Pen Down, MoveTo (P ("x2", "y2")), Pen Up]



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

-- Main function (help)
main = do
    putStrLn "HW2 Loading! Available helper functions:"
    --putStrLn " ~= bg_test  :  test Bag functions"
    --putStrLn " ~= gr_test  :  test Graph functions"
    --putStrLn " ~= sh_test  :  test Shape functions"
    putStrLn " "