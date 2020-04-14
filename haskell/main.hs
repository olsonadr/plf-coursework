main :: IO()
main = print ("File loaded!")


-- Creating Bag type --
type Bag a = [(a, Int)]


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

