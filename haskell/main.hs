
-- Creating necessary types --
type Number = Int

type Point  = (Number,Number)
type Length = Number

data Shape  = Pt Point                  -- center
            | Circle Point Length       -- center radius
            | Rect Point Length Length  -- lower-left, width, height
            deriving Show

type Figure = [Shape]

type BBox   = (Point,Point) -- (lower-left, upper-right)


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
