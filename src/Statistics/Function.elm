module Statistics.Function exposing (mean, stdev)


mean : List Float -> Float
mean numbers =
    let
        n =
            List.length numbers |> toFloat
    in
    List.sum numbers / n


variance : List Float -> Float
variance numbers =
    numbers
        |> center
        |> sumOfSquares


stdev : List Float -> Float
stdev numbers =
    let
        n =
            List.length numbers |> toFloat

        averageVariance =
            variance numbers / (n - 1)
    in
    sqrt averageVariance


center : List Float -> List Float
center numbers =
    let
        m =
            mean numbers
    in
    List.map (\x -> x - m) numbers


sumOfSquares : List Float -> Float
sumOfSquares numbers =
    numbers
        |> List.map (\x -> x * x)
        |> List.sum
