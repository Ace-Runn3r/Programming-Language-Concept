{-
 - Author: Cole Clements, cclements2016@my.fit.edu
 - Course: CSE 4250, Fall 2019
 - Project: Proj4, Decoding Text
 - Language implementation: Haskell?
 -}
 
module Main where

data Tree = Leaf Char | Branch Tree Tree deriving (Show)

-- create the tree from list passing 
-- remainder up recusivly
createTree :: [Char] -> (Tree, [Char])
createTree ('*':rest) = (Branch left right, leftoversR)
            where 
            (left, leftoversL) = createTree (rest)
            (right, leftoversR) = createTree (leftoversL)
createTree (x:rest) = (Leaf x, rest)
createTree ([]) = (Leaf '_',[])

-- concat leafs fetched from decode
decoder :: Tree -> [Char] -> [Char]
decoder _ [] = []
decoder tre str = fst (decode tre str) ++ (decoder tre (snd (decode tre str)))

-- recur down tree until leaf is found and return 
-- leafs value and the remainder of the list
-- so we can find the next encoded char
decode :: Tree -> [Char] -> ([Char],[Char])
decode (Leaf x) (str) = ([x], str)
decode (Branch _ _) [] = ([],[])
decode (Branch l r) (str:rest) | str == '0' = decode l rest
                               | str == '1' = decode r rest
                               | otherwise = undefined

-- take in decode input and create output
outputFormat :: Tree -> [String] -> [Char]
outputFormat _ [] = []
outputFormat tre str = decoder tre (head str) ++ "\n" ++ outputFormat tre (tail str)

-- take in input lines and parse them
sepInput :: [Char] -> [Char]
sepInput input = let inputLines = lines input
                     encoding = head inputLines -- first line used to make tree
                     decodings = tail inputLines -- rest of lines used to decode
                     encodedTree = fst (createTree encoding) -- grab tree and not list
                 in  outputFormat encodedTree decodings
                 
main :: IO()
main = interact (sepInput)
