import Data.List (sort)
import Data.List (sortBy)

parseHands :: [[Char]] -> [([Int],Int)]
parseHands [] = []
parseHands (x:y:xs) = (map cardvalues x,read y):(parseHands xs)
  where
    cardvalues :: Char -> Int
    cardvalues x
      | x == 'A' = 14
      | x == 'K' = 13
      | x == 'Q' = 12
      | x == 'J' = 1
      | x == 'T' = 10
      | otherwise = read [x]

countUnique :: Eq a => [a] -> [Int]
countUnique [] = []
countUnique (x:xs) = (1 + length (filter (==x) xs)):countUnique(filter (/=x) xs)

scoreHand :: [Int] -> [Int]
scoreHand x
  | x == [1,1,1,1,1] = [5,0,1,1,1,1,1] -- kludge, obvi, but if we do this then we can just feed a filtered list to count Unique and it works.
  | otherwise = (incFst jokers twoSets)++x
  where twoSets = take 2 (sortDesc . countUnique $ filter (/=1) x)
        jokers = length $ filter (==1) x
        incFst _ [] = []
        incFst i (y:ys) = (y+i):ys

compareHands :: ([Int],Int) -> ([Int],Int) -> Ordering
compareHands a b = flip compare (scoreHand . fst $ a) (scoreHand . fst $ b)

sortDesc = sortBy (flip compare)

tally :: [Int] -> Int
tally [] = 0
tally (x:xs) = x*(1+ length xs) + tally xs

main :: IO ()
main = do
  contents <- getContents
  let hands = parseHands $ words contents
  let sHands = sortBy compareHands hands
  --let counts = sort . countUnique . fst $ hands
  let answer = tally $ map snd sHands
  print answer
