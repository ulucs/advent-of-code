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

    let machine =
        OpcodeMachine.build (function
            | 1 -> Some((fun [ x; y ] -> x + y), 3)
            | 2 -> Some((fun [ x; y ] -> x * y), 3)
            | _ -> None)

    let silverM =
        machine
            [ 1, 12
              2, 2 ]
        >> Array.head

    let goldM (input: int []) =
        Utils.cartesian [ 1 .. 99 ] [ 1 .. 99 ]
        |> List.map (fun (i, j) ->
            (machine
                [ 1, i
                  2, j ], 100 * i + j))
        |> List.map (fun (f, c) -> (f input |> Array.head, c))
        |> List.find (fun (v, _) -> v = 19690720)
        |> (fun (_, c) -> c)

    printf "%d\n" (silver input)
    printf "%d\n" (silverM input)
    printf "%d\n" (gold input)
    printf "%d\n" (goldM input)
