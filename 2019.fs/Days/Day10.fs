namespace AoC

module Day10 =
    let pairDiff (a, b) (x, y) = (x - a, y - b)
    let norm i j = abs (i) + abs (j)

    let normed (i, j) =
        let d = norm i j
        (i / d, j / d), d

    let unNormed (x, y) d = x * d, y * d

    let (|Positive|_|) x =
        if x > 0.0 then Some()
        else None

    let (|NotNegative|_|) x =
        if x >= 0.0 then Some()
        else None

    let input = Utils.getInputLines 10

    let planetLocs =
        Array.indexed
        >> Array.map (fun (i, l) ->
            Array.ofSeq l
            |> Array.indexed
            |> Array.filter (fun (_, p) -> p = '#')
            |> Array.map (fun (j, _) -> (float j, float i)))
        >> Array.concat

    let angleSorter (x, y) =
        match (x, -y) with
        | NotNegative, Positive -> x
        | NotNegative, _ -> 2.0 - x
        | _, Positive -> 4.0 + x
        | _, _ -> 2.0 - x

    let countPlanetsSeen planets observer =
        observer,
        planets
        |> Array.filter ((<>) observer)
        |> Array.map (pairDiff observer >> normed)
        |> Map.ofArray

    let silver input =
        input
        |> Array.map (countPlanetsSeen input)
        |> Array.maxBy (fun (_, j) -> Map.count j)
        |> (fun (i, j) -> i, Map.count j)

    let gold planets =
        let observer = 19.0, 14.0
        let (ox, oy) = observer

        planets
        |> Array.filter ((<>) observer)
        |> Array.map (pairDiff observer >> normed)
        |> Array.sortBy (fun (_, d) -> d)
        |> Array.fold (fun (pts, turnCounts) ((x, y), d) ->
            match Map.tryFind (x, y) turnCounts with
            | None -> (0, (x, y), d) :: pts, Map.add (x, y) 1 turnCounts
            | Some(t) -> (t, (x, y), d) :: pts, Map.add (x, y) (t + 1) turnCounts) ([], Map.empty)
        |> (fun (x, _) -> x)
        |> List.sortBy (fun (t, r, d) -> t, angleSorter r)
        |> List.item 199
        |> (fun (_, r, d) -> unNormed r d)
        |> (fun (x, y) -> x + ox, y + oy)

        List.con

    silver planetLocs
    |> printf "%A\n"

    gold planetLocs
    |> printf "%A\n"
