main :: IO()
main = print ("File loaded!")

wow :: Int -> [Int]
wow 0 = [0]
wow n = [n*n] ++ wow (n-1)