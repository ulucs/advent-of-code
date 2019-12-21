namespace AoC

open OpcodeMachine

module Day21 =
    let input = Utils.getIntcode 21
    let bi2i (i: bigint) = int i

    let printAscii =
        List.map (bi2i >> char)
        >> Array.ofList
        >> System.String
        >> printfn "%s"

    let inspector = OpcodeMachine.build intructions []

    let hullInspectWalk =
        List.ofSeq "OR A T
AND B T
AND C T
NOT T T
OR D J
AND T J
WALK\n"


    let silver input =
        let spring = inspector input
        let (msg, st) = feedAscii hullInspectWalk spring |> getMessages
        List.last msg

    let hullInspectRun =
        List.ofSeq "OR A T
AND B T
AND C T
NOT T T
OR D J
AND T J
NOT A T
OR H T
AND T J
RUN\n"

    let gold input =
        let spring = inspector input
        let (msg, st) = feedAscii hullInspectRun spring |> getMessages
        List.last msg

    printfn "%A" (silver input)
    printfn "%A" (gold input)
