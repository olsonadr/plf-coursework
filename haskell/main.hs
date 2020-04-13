main :: IO()
main = print ("File loaded!")


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
width (Rect _ w _)  = w -- maybe done? --


-- bbox function: computes the bounding box of the shape --
bbox :: Shape -> BBox
bbox (Pt p) = (p, p) -- incomplete --


-- minX function: computes the minimum x coordinate of the shape --
minX :: Shape -> Number
minX (Pt (x,y)) = x -- incomplete --


-- addPt function: adds the components of two points --
addPt :: Point -> Point -> Point
addPt (x1,y1) (x2,y2) = (x1+x2, y1+y2) -- maybe done? --


-- move function: translates a shape's position by a given vector --
move :: Shape -> Point -> Shape
move (Pt p) d = Pt (addPt p d) -- incomplete --


-- moveToX function: translates a shape's x position to a value --
moveToX :: Shape -> Number -> Shape
moveToX (Pt (_,y)) x = Pt (x,y) -- incomplete --


-- moveAllToX function: translate all shapes in a figure to a x position --
moveAllToX :: Figure -> Number -> Figure
moveAllToX [] _         = []
moveAllToX (sh:[]) x    = [(moveToX sh x)]
moveAllToX (sh:shs) x   = [(moveToX sh x)] ++ (moveAllToX shs x) --maybe complete?--

-- minNum function: finds the smaller of two numbers --
minNum :: Number -> Number -> Number
minNum x1 x2    | x1 <= x2  = x1
                | otherwise = x2 -- maybe complete? --


-- minMinX function: finds smallest minX in a figure --
minMinX :: Figure -> Number
minMinX []          = 0
minMinX (sh:[])     = minX sh
minMinX (sh:shs)    = minNum (minX sh) (minMinX shs) -- maybe complete? --


-- alignLeft function: moves all shapes in a figure to have the same minX value --
alignLeft :: Figure -> Figure
alignLeft []    = []
alignLeft fig   = moveAllToX fig (minMinX fig) -- maybe complete? --


-- inside function: computes if one shape is contained within another --
--inside :: Shape -> Shape -> Bool
-- for this one maybe we check if the bounding box is contained withing the other, unless its a point in a point which takes special consideration because equal points