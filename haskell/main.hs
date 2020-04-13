main :: IO()
main = print ("File loaded!")


-- Creating Bag type --
type Bag a = [(a, Int)]


-- ins function: inserts element into a multiset --
ins :: Eq a => a -> Bag a -> Bag a
ins val b   = [(val, 1)] -- placeholder --


-- del function: removes an element from a multiset --
del :: Eq a => a -> Bag a -> Bag a
del val b   = [(val, 1)] -- placeholder --


-- bag function: converts list of vals into a multiset rep --
bag :: Eq a => [a] -> Bag a
bag []      = []
bag (x:xs)  = [(x, 1)] -- placeholder --


-- subbag function: checks if one bag is contained in the second --
subbag :: Eq a => Bag a -> Bag a -> Bool
subbag [] _     = True
subbag b1 b2    | size b1 > size b2 = False
                | otherwise = True -- placeholder --


-- isbag function: computes intersection of two multisets --
isbag :: Eq a => Bag a -> Bag a -> Bag a
isbag [] _      = []
isbag _ []      = []
isbag b1 b2     = b1 -- placeholder --


-- size function: computes number of elements in a multiset --
size :: Bag a -> Int
size []         = 0
size ((x,n):xs) = n + size xs
