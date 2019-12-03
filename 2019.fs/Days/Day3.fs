namespace AoC

open Utils

module Day3 =
    type dirs =
        | L
        | U

    let input =
        (getInputLines 3)
        |> Array.map (fun s -> s.Trim().Split(","))
        |> Array.map
            (Array.map (function
                | Prefix "L" rest -> (L, int rest)
                | Prefix "R" rest -> (L, -int rest)
                | Prefix "U" rest -> (U, int rest)
                | Prefix "D" rest -> (U, -int rest)))

    let dist (l1, r1) (l2, r2) = abs (l1 - l2) + abs (r1 - r2)

    let points =
        Array.fold (fun ((l, r) :: rest) (dir, dx: int) ->
            match dir with
            | L -> cartesian [ l ] [ (r + dx) .. -sign dx .. (r + sign dx) ]
            | R -> cartesian [ (l + dx) .. -sign dx .. (l + sign dx) ] [ r ]
            |> List.append
            <| rest) [ (0, 0) ]

    let pointsWithSteps =
        Array.fold (fun (((l, r), s: int) :: rest) (dir, dx: int) ->
            match dir with
            | L -> cartesian [ l ] [ (r + dx) .. -sign dx .. (r + sign dx) ]
            | R -> cartesian [ (l + dx) .. -sign dx .. (l + sign dx) ] [ r ]
            |> List.zip
            <| [ (s + abs (dx)) .. -1 .. (s + 1) ]
            |> List.append
            <| rest) [ ((0, 0), 0) ]

    let silver (input: (dirs * int) [] []) =
        let pts1 = points input.[0] |> Set.ofList
        let pts2 = points input.[1] |> Set.ofList

        Set.intersect pts1 pts2
        |> Set.map (dist (0, 0))
        |> Set.minElement

    let gold (input: (dirs * int) [] []) =
        let pts1 = points input.[0] |> Set.ofList
        let pts2 = points input.[1] |> Set.ofList

        let pts1s = pointsWithSteps input.[0] |> Map.ofList
        let pts2s = pointsWithSteps input.[1] |> Map.ofList

        Set.intersect pts1 pts2
        |> Set.map (fun pt -> pts1s.Item(pt) + pts2s.Item(pt))
        |> Set.minElement

    printf "%A\n" (silver input)
    printf "%A\n" (gold input)
