namespace AoC

module Day2 =
    let input = (Utils.getInput 2).Trim().Split(",") |> Array.map int
    let inputC = Array.copy input
    let inputLen = Array.length input

    let rec comp (input: int []) pos =
        match input.[pos] with
        | 1 -> Array.set input input.[pos + 3] (input.[input.[pos + 1]] + input.[input.[pos + 2]])
        | 2 -> Array.set input input.[pos + 3] (input.[input.[pos + 1]] * input.[input.[pos + 2]])
        | _ -> ()

        match input.[pos] with
        | 1
        | 2 -> comp input ((pos + 4) % inputLen)
        | _ -> input

    let silver input =
        Array.set input 1 12
        Array.set input 2 2

        comp input 0

    printf "%d\n" (silver input).[0]

    let gold (input: int []) =
        for i in 1 .. 99 do
            for j in 1 .. 99 do
                let inp = Array.copy inputC
                Array.set inp 1 i
                Array.set inp 2 j
                if ((comp inp 0).[0] = 19690720) then printf "%d" (100 * i + j)

    gold inputC
