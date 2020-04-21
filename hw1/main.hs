module HW1 where

-- ====================================== --
-- ========= Importing Utils ============ --
-- ====================================== --

import Data.List (nub,sort)
norm :: Ord a => [a] -> [a]
norm = sort . nub



-- ====================================== --
-- ========= Defining Datatypes ========= --
-- ====================================== --

-- For Bags --
type Bag a = [(a, Int)]


-- For Graphs --
type Node   = Int
type Edge   = (Node,Node)
type Graph  = [Edge]
type Path   = [Node]


-- For Shapes --
type Number = Int
type Point  = (Number,Number)
type Length = Number
data Shape  = Pt Point                  -- center
            | Circle Point Length       -- center radius
            | Rect Point Length Length  -- lower-left, width, height
            deriving Show
type Figure = [Shape]
type BBox   = (Point,Point) -- (lower-left, upper-right)



-- ====================================== --
-- ============ Bag functions =========== --
-- ====================================== --
    
-- ins function: inserts element into a multiset --
ins :: Eq a => a -> Bag a -> Bag a
ins y []                        = [(y, 1)]
ins y ((x,n):xs)    | x == y    = [(x,n+1)] ++ xs
                    | otherwise = [(x,n)] ++ (ins y xs)


-- del function: removes an element from a multiset --
del :: Eq a => a -> Bag a -> Bag a
del y []                                = []
del y ((x,n):xs)    | x == y && n == 1  = xs
                    | x == y            = [(x,n-1)] ++ xs
                    | otherwise         = [(x,n)] ++ (del y xs)


-- bag function: converts list of vals into a multiset rep --
bag :: Eq a => [a] -> Bag a
bag []      = []
bag (x:xs)  = (ins x (bag xs))


-- size function: computes number of elements in a multiset --
size :: Bag a -> Int
size []         = 0
size ((x,n):xs) = n + size xs


-- getOccur function: get number of occurences of a value x in a bag --
getOccur :: Eq a => a -> Bag a -> Int
getOccur _ []           = 0
getOccur y ((x,n):xs)   | y == x    = n
                        | otherwise = getOccur y xs


-- isbag function: computes intersection of two multisets --
isbag :: Eq a => Bag a -> Bag a -> Bag a
isbag [] _          = []
isbag ((x,n):xs) b2 | (getOccur x b2) == 0  = isbag xs b2
                    | (getOccur x b2) > n   = [(x,n)] ++ isbag xs b2 ++ isbag xs b2
                    | otherwise             = [(x,(getOccur x b2))] ++ isbag xs b2
                    

-- pairsPresent function: checks if occurences of every value in b1 is same in b2 --
pairsPresent :: Eq a => Bag a -> Bag a -> Bool
pairsPresent [] _           = True
pairsPresent ((x,n):xs) b2  | (getOccur x b2) == n  = pairsPresent xs b2
                            | otherwise             = False


-- bagsEqual function: check if two bags are identical in values and occurences --
bagsEqual :: Eq a => Bag a -> Bag a -> Bool
bagsEqual b1 b2 | (pairsPresent b1 b2) && (pairsPresent b2 b1) = True
                | otherwise = False


-- subbag function: checks if one bag is contained in the second --
subbag :: Eq a => Bag a -> Bag a -> Bool
subbag [] _             = True
subbag b1 b2            = bagsEqual b1 (isbag b1 b2)



-- ====================================== --
-- =========== Graph functions ========== --
-- ====================================== --

-- compileAllNodes function: adds every node of each edge (duplicating) to list --
compileAllNodes :: Graph -> [Node]
compileAllNodes [] = []
compileAllNodes ((n1,n2):[]) = [n1] ++ [n2]
compileAllNodes ((n1,n2):es) = [n1] ++ [n2] ++ (nodes es)


-- nodes function: computes list of nodes in a graph --
nodes :: Graph -> [Node]
nodes [] = []
nodes gr = norm (compileAllNodes gr)


-- suc function: computes list of successors of a node in a graph --
suc :: Node -> Graph -> [Node]
suc _ []            = []
suc x ((n1,n2):es)  | x == n1   = [n2] ++ (suc x es)
                    | otherwise = suc x es


-- detach function: removes a node and its edges from a graph --
detach :: Node -> Graph -> Graph
detach _ [] = []
detach n1 ((n2,n3):es) | (n1 == n2) || (n1 == n3)   = detach n1 es
                       | otherwise                  = [(n2,n3)] ++ (detach n1 es)


-- cyc function: creates a cycle for a given number of nodes (including (1,N) --
cyc :: Int -> Graph
cyc 0 = []
cyc n = (actualCyc n) ++ [(n,1)]


-- actualCyc function: recursively creates a cycle (except for the edge (1,N) )
actualCyc :: Int -> Graph
actualCyc n     | n >= 2      = (actualCyc (n-1)) ++ [(n-1,n)]
                | otherwise   = []



-- ====================================== --
-- =========== Shape functions ========== --
-- ====================================== --

-- width function: computes the width of a shape --
width :: Shape -> Length
width (Pt _)        = 0
width (Circle _ r)  = r+r
width (Rect _ w _)  = w


-- addPt function: adds the components of two points --
addPt :: Point -> Point -> Point
addPt (x1,y1) (x2,y2) = (x1+x2, y1+y2)


-- bbox function: computes the bounding box of the shape --
bbox :: Shape -> BBox
bbox (Pt p)         = (p, p)
bbox (Circle c r)   = ((addPt c (-r,-r)), (addPt c (r,r)))
bbox (Rect p1 w h)  = (p1, (addPt p1 (w,h)))


-- minX function: computes the minimum x coordinate of the shape --
minX :: Shape -> Number
minX (Pt (x,_))         = x
minX (Circle (cx,_) r)  = cx - r
minX (Rect (x,_) _ _)   = x


-- move function: translates a shape's position by a given vector --
move :: Shape -> Point -> Shape
move (Pt p) d       = (Pt (addPt p d))
move (Circle c r) d = (Circle (addPt c d) r)
move (Rect p w h) d = (Rect (addPt p d) w h)


-- moveOriginToX function: translates a shape's origin x position to a value --
moveOriginToX :: Shape -> Number -> Shape
moveOriginToX (Pt (_,y)) x        = (Pt (x,y))
moveOriginToX (Circle (_,y) r) x  = (Circle (x,y) r)
moveOriginToX (Rect (_,y) w h) x  = (Rect (x,y) w h)


-- moveLeftEdgeToX function: translates a shape's left edge to an x value --
moveLeftEdgeToX :: Shape -> Number -> Shape
moveLeftEdgeToX (Pt (_,y)) x        = (Pt (x,y))
moveLeftEdgeToX (Circle (_,y) r) x  = (Circle (x+r,y) r)
moveLeftEdgeToX (Rect (_,y) w h) x  = (Rect (x,y) w h)


-- moveAllOriginToX function: translate all shapes' origins in a figure to a x position --
moveAllOriginToX :: Figure -> Number -> Figure
moveAllOriginToX [] _         = []
moveAllOriginToX (sh:[]) x    = [(moveOriginToX sh x)]
moveAllOriginToX (sh:shs) x   = [(moveOriginToX sh x)] ++ (moveAllOriginToX shs x)


-- moveAllLeftEdgeToX function: translate all shapes' left edges in fig to an x --
moveAllLeftEdgeToX :: Figure -> Number -> Figure
moveAllLeftEdgeToX [] _         = []
moveAllLeftEdgeToX (sh:[]) x    = [(moveLeftEdgeToX sh x)]
moveAllLeftEdgeToX (sh:shs) x   = [(moveLeftEdgeToX sh x)] ++ (moveAllLeftEdgeToX shs x)


-- minNum function: finds the smaller of two numbers --
minNum :: Number -> Number -> Number
minNum x1 x2    | x1 <= x2  = x1
                | otherwise = x2


-- minMinX function: finds lowest minX of the shapes in a figure --
minMinX :: Figure -> Number
minMinX []          = 0
minMinX (sh:[])     = minX sh
minMinX (sh:shs)    = minNum (minX sh) (minMinX shs)


-- alignLeft function: moves all shapes in a figure to have the same minX value --
alignLeft :: Figure -> Figure
alignLeft []    = []
alignLeft fig   = moveAllLeftEdgeToX fig (minMinX fig)


-- bboxInside function: compute if one bbox is inside another --
bboxInside :: BBox -> BBox -> Bool
bboxInside ((x1,y1),(x2,y2)) ((x3,y3),(x4,y4)) = ((x1 >= x3 && y1 >= y3) && (x2 <= x4 && y2 <= y4))


-- dist function: computes distance between two points
dist :: Point -> Point -> Float
dist (x1,y1) (x2,y2) = (sqrt.fromIntegral) (((x2-x1)*(x2-x1)) + ((y2-y1)*(y2-y1)))


-- absol function: finds the absolute value of a Number
absol :: Number -> Number
absol x | x < 0       = 0-x
        | otherwise   = x


-- absolPoint function: finds the absolute value of each component of a point
absolPoint :: Point -> Point
absolPoint (x,y) = (absol x, absol y)


-- inside function: computes if one shape is contained within another --
inside :: Shape -> Shape -> Bool
inside (Circle c1 r1) (Circle c2 r2)    = (((dist c1 c2) + fromIntegral r1) <= fromIntegral r2)
inside (Pt p) (Circle c r)              = ((dist c p) <= fromIntegral r)
inside (Rect p w h) (Circle c r)        = ((dist c p) <= fromIntegral r) && ((dist c (addPt p (w,h))) <= fromIntegral r)
inside sh1 sh2                          = bboxInside (bbox sh1) (bbox sh2)



-- ====================================== --
-- =========== Function tests =========== --
-- ====================================== --

-- Bag Unit tests
test_bag = [(5,1),(7,3),(2,1),(3,2),(8,1)]
bg_test = do
    print ""
    print "~--      Bags      --~"
    print ("Insertion == {")
    print ("    " ++ show (ins 99 test_bag == [(5,1),(7,3),(2,1),(3,2),(8,1),(99,1)]))
    print ("    " ++ show (ins 3 test_bag == [(5,1),(7,3),(2,1),(3,3),(8,1)]))
    print ("    " ++ show ((ins 7 $ ins 8 test_bag) == [(5,1),(7,4),(2,1),(3,2),(8,2)]))
    print ("}")
    print ("Deletion  == {")
    print ("    " ++ show (del 99 test_bag == test_bag))
    print ("    " ++ show (del 3 test_bag == [(5,1),(7,3),(2,1),(3,1),(8,1)]))
    print ("    " ++ show (del 2 test_bag == [(5,1),(7,3),(3,2),(8,1)]))
    print ("}")
    print ("Creation  == {")
    print ("    " ++ show (bag [2,3,3,5,7,7,7,8] == [(8,1),(7,3),(5,1),(3,2),(2,1)]))
    print ("    " ++ show (bag [7,3,8,7,3,2,7,5] == [(5,1),(7,3),(2,1),(3,2),(8,1)]))
    print ("}")
    print ("Subbag    == {")
    print ("    " ++ show (subbag [(5,1),(7,5),(2,1),(3,2),(8,1)] test_bag == False))
    print ("    " ++ show (subbag [(5,1),(7,1),(2,1),(3,1),(8,1)] test_bag == True))
    print ("    " ++ show (subbag [(5,1),(7,3),(2,1),(8,1)] test_bag == True))
    print ("    " ++ show (subbag test_bag [(5,1),(7,3),(2,1),(8,1)] == False))
    print ("    " ++ show (subbag test_bag test_bag == True))
    print ("}")
    print ("IsBag     == {")
    print ("    " ++ show (isbag [(5,2),(7,3),(2,1),(8,1)] [(5,1),(99,1)] == [(5,1)]))
    print ("    " ++ show (isbag [(1, 1)] [] == []))
    print ("    " ++ show (isbag [] [(1, 1)] == []))
    print ("}")
    print ("Size      == {")
    print ("    " ++ show (size [] == 0))
    print ("    " ++ show (size [(1, 1)] == 1))
    print ("    " ++ show (size [(1, 8)] == 8))
    print ("    " ++ show (size [(1, 3),(2,7)] == 10))
    print ("    " ++ show (size test_bag == 8))
    print ("}")


-- Graph Unit Tests
g :: Graph
g = [(1,2),(1,3),(2,3),(2,4),(3,4)]
h :: Graph
h = [(1,2),(1,3),(2,1),(3,2),(4,4)]
gr_test = do
    print ""
    print "~--      Graphs      --~"
    print ("Nodes     == {")
    print ("    " ++ show (nodes g == [1,2,3,4]))
    print ("    " ++ show (nodes h == [1,2,3,4]))
    print ("    " ++ show (nodes [(1, 0)] == [0,1]))
    print ("}")
    print ("Suc       == {")
    print ("    " ++ show (suc 2 g == [3, 4]))
    print ("    " ++ show (suc 2 h == [1]))
    print ("}")
    print ("Detach    == {")
    print ("    " ++ show (detach 3 g == [(1,2),(2,4)]))
    print ("    " ++ show (detach 2 h == [(1,3),(4,4)]))
    print ("}")
    print ("Cyc       ==  " ++ show (cyc 4 == [(1,2),(2,3),(3,4),(4,1)]))


-- Shape Unit Tests
f = [Pt (4,4), Circle (5,5) 3, Rect (3,3) 7 2]
sh_test = do
    print ""
    print "~--      Shapes      --~"
    print ("Width     ==  " ++ show (map width f == [0,6,7]))
    print ("BBox      ==  " ++ show (map bbox f == [((4,4),(4,4)),((2,2),(8,8)),((3,3),(10,5))]))
    print ("MinX      ==  " ++ show (map minX f == [4,2,3]))
    print ("Move      ==  " ++ show ((show (map (\l -> move l (1, -2)) f)=="[Pt (5,2),Circle (6,3) 3,Rect (4,1) 7 2]")))
    print ("AlignLeft ==  " ++ show (map minX (alignLeft f) == [2, 2, 2]))
    print ("Inside    == {")
    print ("    " ++ show (inside (Pt (1, 1)) (Pt (1, 1)) == True))
    print ("    " ++ show (inside (Pt (1, 2)) (Pt (1, 1)) == False))
    print ("    " ++ show (inside (Pt (1, 2)) (Rect (1, 1) 5 6) == True))
    print ("    " ++ show (inside (Rect (1, 1) 5 6) (Pt (1, 2)) == False))
    print ("    " ++ show (inside (Circle (1, 1) 1) (Circle (0, 0) 6) == True))
    print ("    " ++ show (inside (Circle (1, 1) 6) (Circle (0, 0) 1) == False))
    print ("    " ++ show (inside (Circle (1, 1) 6) (Circle (1, 1) 6) == True))
    print ("    " ++ show (inside (Circle (9, 9) 1) (Circle (0, 0) 10) == False))
    print ("    " ++ show (inside (Rect (1, 1) 3 4) (Rect (0, 0) 5 6) == True))
    print ("    " ++ show (inside (Circle (1, 1) 4) (Rect (0, 0) 2 2) == False))
    print ("    " ++ show (inside (Circle (1, 1) 1) (Rect (0, 0) 2 2) == True))
    print ("    " ++ show (inside (Rect (0, 0) 1 1) (Circle (0, 0) 8) == True))
    print ("    " ++ show (inside (Rect (0, 0) 1 1) (Circle (0, 0) 1) == False))
    print ("}")

-- Main function (help)
main = do
    putStrLn "HW1 Loading! Available helper functions:"
    putStrLn " ~= bg_test  :  test Bag functions"
    putStrLn " ~= gr_test  :  test Graph functions"
    putStrLn " ~= sh_test  :  test Shape functions"
    putStrLn " "