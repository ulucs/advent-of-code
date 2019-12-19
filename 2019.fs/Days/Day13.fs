namespace AoC

open OpcodeMachine

module Day13 =
    let input = Utils.getIntcode 13

    let display = OpcodeMachine.build intructions []
    let game = OpcodeMachine.build intructions [ 0, 2I ]
    let bi2i (b: bigint) = int b
    let bigint (i: int) = bigint i

    let withDefault j =
        function
        | None -> j
        | Some(i) -> i

    let silver input =
        display input
        |> getMessages
        |> List.chunkBySize 3
        |> List.filter (List.last >> (=) 2I)
        |> List.length

    let getStats msgs =
        msgs
        |> List.map bi2i
        |> List.chunkBySize 3
        |> List.fold (fun m [ i; j; t ] ->
            if (i, j) = (-1, 0) then Map.add "score" (t, 0) m
            else if t = 3 then Map.add "paddle" (i, j) m
            else if t = 4 then Map.add "ball" (i, j) m
            else m) Map.empty

    let rec play padMem console =
        let msgs, next = getMessagesAndStatus console []
        let locs = getStats msgs
        let (pi, pj) = withDefault padMem (Map.tryFind "paddle" locs)

        match next, Map.tryFind "ball" locs with
        | Waiting(f), Some(bi, _) ->
            bi - pi
            |> sign
            |> i2bi
            |> f
            |> play (pi, pj)
        | _ -> locs

    let gold input =
        let console = game input
        play (0, 0) console |> Map.find "score"

    printfn "%A" (silver input)
    printfn "%A" (gold input)
