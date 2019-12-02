namespace AoC

module Day2 =
    let input = (Utils.getInput 2).Trim().Split(",") |> Array.map int
    let inputLen = Array.length input

    let rec comp (input: int []) pos =
        match input.[pos] with
        | 1 ->
            Array.set input input.[pos + 3] (input.[input.[pos + 1]] + input.[input.[pos + 2]])
            comp input ((pos + 4) % inputLen)
        | 2 ->
            Array.set input input.[pos + 3] (input.[input.[pos + 1]] * input.[input.[pos + 2]])
            comp input ((pos + 4) % inputLen)
        | _ -> input

    let silver inputC =
        let input = Array.copy inputC
        Array.set input 1 12
        Array.set input 2 2

        (comp input 0).[0]

    let gold (input: int []) =
        Utils.cartesian [ 1 .. 99 ] [ 1 .. 99 ]
        |> List.map (fun (i, j) ->
            let inp = Array.copy input
            Array.set inp 1 i
            Array.set inp 2 j
            ((comp inp 0).[0], 100 * i + j))
        |> List.find (fun (a, _) -> a = 19690720)
        |> (fun (_, j) -> j)


    printf "%d\n" (silver input)
    printf "%d\n" (gold input)
