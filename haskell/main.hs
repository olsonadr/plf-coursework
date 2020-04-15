
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