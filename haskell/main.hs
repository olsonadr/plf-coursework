main :: IO()
main = print ("File loaded!")


-- Import recommended utilities --
import HW1types


-- Creating necessary types --
type Node   = Int
type Edge   = (Node,Node)
type Graph  = [Edge]
type Path   = [Node]


-- nodes function: computes list of nodes in a graph --
nodes :: Graph -> [Node]
nodes [] = [] -- placeholder --


-- suc function: computes list of successors of a node in a graph --
suc :: Node -> Graph -> [Node]
suc _ [] = []
suc x gr = [] -- placeholder --


-- detach function: removes a node and its edges from a graph --
detach :: Node -> Graph -> Graph
detach _ [] = []
detach x gr = gr -- placeholder --


-- cyc function: creates a cycle for a given number of nodes --
cyc :: Int -> Graph
cyc 0 = []
cyc n = [] -- placeholder --