namespace AoC

module Day16 =
    let rev f x y = f y x
    let bigint (x: int) = bigint (x)

    let input =
        Utils.getInput 16
        |> Array.ofSeq
        |> Array.map string
        |> Array.map int

    let phased input i =
        let al = Array.length input
        let mutable j = i
        let mutable acc = 0
        let mutable sgn = 1
        while (j < al) do
            let la = (min (j + i) (al - 1)) % al
            let lj = j % al
            acc <- acc + sgn * (Array.sum input.[lj..la])
            j <- j + 2 * (i + 1)
            sgn <- -sgn
        abs (acc % 10)

    let fftp input = Array.map (phased input) [| 0 .. (Array.length input) - 1 |]

    let silver input =
        let mutable inp = input
        for i in [ 1 .. 100 ] do
            // printfn "Iteration: %3d" i
            inp <- fftp inp

        inp
        |> Array.take 8
        |> Array.toList

    let getRowSum (input: int []) n =
        let divisor = List.reduce (*) [ 1I .. 99I ]
        //printfn "%d" divisor

        let mutable acc = 0
        for i in [ n .. 650 * 10000 ] do
            [ (i - n + 1) .. (i - n + 99) ]
            |> List.map (bigint)
            |> List.reduce (*)
            |> rev (/) divisor
            |> rev (%) 10I
            |> (fun m ->
            if m <> 0I then acc <- acc + (int m) * input.[i % 650])
        acc % 10

    let gold input = [ 5976267 .. 5976267 + 7 ] |> List.map (getRowSum input)

    printfn "%A" (gold input)
