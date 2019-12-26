namespace AoC

open OpcodeMachine

module Day25 =
    let input = Utils.getIntcode 25

    let machine = OpcodeMachine.build intructions []

    let (|Contains|_|) (str: string) (msg: string) =
        if msg.Contains(str) then Some() else None

    let rec repl st =
        match getAsciiMsg st with
        | msg, Halted -> printfn "%s" msg
        | msg, newSt ->
            printfn "%s" msg
            let command = System.Console.ReadLine()
            repl (feedAsciin command newSt)

    let remove dropped = List.filter ((<>) dropped)
    let rev f x y = f y x

    let rec bfDoor st inv floor heavyCombs =
        match getAsciiMsg st with
        | Contains "lighter", newSt ->
            let drop = (new System.Random()).Next(Set.count inv)
            let dropped = Set.toList inv |> List.item drop

            let command =
                sprintf "drop %s\neast" dropped
            bfDoor (feedAsciin command newSt) (Set.remove dropped inv) (Set.add dropped floor) (Set.add inv heavyCombs)
        | Contains "heavier", newSt ->
            let taken =
                Seq.unfold (fun () ->
                    Set.toList floor |> List.item ((new System.Random()).Next(Set.count floor)) |> (fun v -> Some(v, ()))) ()
                |> Seq.find (fun tk -> Set.contains (Set.add tk inv) heavyCombs |> (not))
    
            let command =
                sprintf "take %s\neast" taken
            bfDoor (feedAsciin command newSt) (Set.add taken inv) (Set.remove taken floor) heavyCombs
        | msg, newSt ->
            printfn "%s" msg
            repl newSt

    let silver input =
        let robo = machine input
        let pathToDoor =
            [ "north\nnorth\nnorth"
              "take mutex"
              "south\nsouth\neast\nnorth"
              "take loom"
              "south\nwest\nsouth\neast\neast"
              "take ornament"
              "west"
              "take semiconductor"
              "west\nwest\nwest"
              "take sand"
              "south\neast"
              "take asterisk"
              "north"
              "take wreath"
              "south\nwest\nnorth\nnorth"
              "take dark matter"
              "east\neast" ]

        bfDoor (List.fold (rev feedAsciin) robo pathToDoor)
            ([ "mutex"; "loom"; "ornament"; "semiconductor"; "sand"; "asterisk"; "dark matter"; "wreath" ] |> Set.ofList)
            (Set.ofList []) Set.empty

    silver input
