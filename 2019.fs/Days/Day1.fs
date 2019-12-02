namespace AoC

module Day1 =
    let input = Utils.getInputLines 1 |> Array.map int

    let silver input =
        input
        |> Array.map (fun a -> a / 3 - 2)
        |> Array.fold (+) 0

    let gold input =
        input
        |> Array.map
            (Seq.unfold (fun fuel ->
                if (fuel <= 0) then None
                else Some(fuel, fuel / 3 - 2)))
        |> Array.map (Seq.filter (fun a -> a > 0))
        |> Array.map Seq.tail
        |> Array.map (Seq.fold (+) 0)
        |> Array.fold (+) 0

    printf "%d\n" (silver input)
    printf "%d\n" (gold input)
