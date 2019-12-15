namespace AoC

open OpcodeMachine

module Day15 =
    let input = (Utils.getInput 15).Split(",") |> Array.map (int >> i2bi)

    let machine = OpcodeMachine.build intructions [] input

    let rev f x y = f y x

    let first (x, _) = x
    let second (_, y) = y
    let firsts = List.map first
    let seconds = List.map second

    let move dir (y, x) =
        match int dir with
        | 1 -> (y - 1), x
        | 2 -> (y + 1), x
        | 3 -> y, (x - 1)
        | 4 -> y, (x + 1)

    let getMoves cont loc =
        [ 1I; 2I; 3I; 4I ]
        |> List.map (fun d -> (cont d), (move d loc))
        |> List.filter (fun (s, _) ->
            match s with
            | Message(j, _) when j = 0I -> false
            | Message(i, Waiting(f)) -> true
            | _ -> false)
        |> List.map (fun (s, l) ->
            match s with
            | Message(i, Waiting(f)) -> (i, (l, f)))

    let rec silver seen frontier steps =
        let (msgs, newFrontier) =
            List.map (fun (l, f) -> getMoves f l) frontier
            |> List.concat
            |> List.unzip

        if List.contains 2I msgs then
            newFrontier.Item(List.findIndex ((=) 2I) msgs), steps
        else
            let newSeen = List.fold (rev Set.add) seen (firsts frontier)

            let nf =
                newFrontier
                |> List.filter
                    (first
                     >> rev Set.contains seen
                     >> (not))
            silver newSeen nf (steps + 1)

    let rec gold seen frontier steps =
        let newFrontier =
            List.map (fun (l, f) -> getMoves f l) frontier
            |> List.concat
            |> seconds
            |> List.filter
                (first
                 >> rev Set.contains seen
                 >> (not))

        if List.isEmpty newFrontier then
            steps
        else
            let newSeen = List.fold (rev Set.add) seen (firsts frontier)
            gold newSeen newFrontier (steps + 1)

    match machine with
    | Waiting(f) ->
        let ((nStart, f1), steps) = silver Set.empty [ (0, 0), f ] 0
        printfn "%d" steps
        gold Set.empty [ nStart, f1 ] 0
    |> printfn "%d"
