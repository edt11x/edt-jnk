main = putStrLn "Hello, World!"

foo :: Int -> Int
foo bar = bar * 10 + 4

fib :: Int -> Int
fib n = fibGen 0 1 n

fibGen :: Int -> Int -> Int -> Int
fibGen a b n = case n of
    0 -> a
    n -> fibGen b (a + b) (n - 1)

fibs :: [Int]
fibs = 0 : 1 : [ a + b | (a, b) <- zip fibs (tail fibs)]

