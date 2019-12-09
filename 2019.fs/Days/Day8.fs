namespace AoC

module Day8 =
    type colors =
        | Black
        | White
        | Transparent

    let toColor =
        function
        | 1 -> White
        | 0 -> Black
        | 2 -> Transparent

    let printer =
        function
        | White -> "@"
        | Black -> " "
        | Transparent -> "."

    let sumColors a b =
        match a with
        | Transparent -> b
        | c -> c

    let input =
        Utils.getInput 8
        |> List.ofSeq
        |> List.map string
        |> List.map int

    let toImage = List.chunkBySize 25 >> List.chunkBySize 6

    let silver =
        toImage
        >> List.map
            (List.concat
             >> List.countBy id
             >> Map.ofList)
        >> List.minBy (Map.find 0)
        >> (fun k -> k.Item 1 * k.Item 2)

    let gold =
        toImage
        >> List.map (List.map (List.map toColor))
        >> List.reduce (List.map2 (List.map2 sumColors))

    let imagePrinter =
        List.map (List.map printer >> String.concat "")
        >> String.concat "\n"

    silver input
    |> printf "%d\n"

    gold input
    |> imagePrinter
    |> printf "%s\n"
