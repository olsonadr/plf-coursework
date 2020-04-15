
-- Import recommended utilities --
import Data.List (nub,sort)
norm :: Ord a => [a] -> [a]
norm = sort . nub


-- Creating necessary types --
type Node   = Int
type Edge   = (Node,Node)
type Graph  = [Edge]
type Path   = [Node]


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
    