namespace AoC

module Day1 =
    let input = Utils.getInputLines 1 |> Array.map int

    let silver input =
        input
        |> Array.map (fun a -> a / 3 - 2)
        |> Array.fold (+) 0

    let gold input =
        let rec fuelRec rsum mass =
            let fuel = mass / 3 - 2
            if fuel <= 0 then rsum
            else fuelRec (rsum + fuel) fuel

        input
        |> Array.map (fuelRec 0)
        |> Array.fold (+) 0

    printf "%d\n" (silver input)
    printf "%d\n" (gold input)
