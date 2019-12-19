namespace AoC

open OpcodeMachine

#nowarn "25"

module Day19 =
    let input = Utils.getIntcode 19
    let i2bi (i: int) = bigint i

    let drone = OpcodeMachine.build intructions []

    let putDirs (i, j) drone =
        try
            match drone with
            | Waiting(f) -> i2bi i |> f
            |> function
            | Waiting(f) -> i2bi j |> f
            |> function
            | Message(m, rest) -> int m
        with _ -> 0

    let silver input =
        let mutable count = 0
        let drc = drone input
        for i in [ 0 .. 49 ] do
            for j in [ 0 .. 49 ] do
                let pull = putDirs (i, j) drc
                count <- count + pull
        count

    let rec findShipPark drc (l, t) =
        let (r, b) = (l + 99, t + 99)
        match putDirs (l, b) drc, putDirs (r, t) drc with
        | _, 0 -> findShipPark drc (l, t + 1)
        | 0, _ -> findShipPark drc (l + 1, t)
        | _, _ -> (l, t)

    let gold input =
        let drc = drone input
        findShipPark drc (0, 0)

    printfn "%A" (gold input)
