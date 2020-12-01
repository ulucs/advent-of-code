namespace AoC

open System.Text.RegularExpressions

module Santabot =
    type BotBrain =
        { botState: Status<bigint>
          saveState: Status<bigint>
          badItems: Set<string>
          inventory: string list
          currentPath: string list
          msgHist: string list
          frontiers: string list list
          visitedPaths: Set<string list> }

    type BotStatus =
        | Room
        | Other

    let parseOptions optTxt =
        Regex.Matches(optTxt, "- (.*?)\n")
        |> Seq.toList
        |> Seq.map (fun m -> m.Groups.Item(1).Value)
        |> Seq.toList

    let getOptions text title =
        (Regex.Match
            (text,
             (sprintf "%s(?:.+\n)+" title))).Value

    let parseRoomName text =
        Regex.Match(text, "== (.+?) ==").Groups.Item(1).Value

    let rev f x y = f y x

    let (|Contains|_|) (str: string) (msg: string) =
        if msg.Contains(str) then Some() else None

    let (|NewRoom|_|) (msg: string) =
        try 
            Some(parseRoomName msg)
        with
        | _ -> None

    let reverseDir =
        function
        | "east" -> "west"
        | "west" -> "east"
        | "north" -> "south"
        | "south" -> "north"

    let rec powersetr =
        function
        | [] -> [ [] ]
        | h :: t -> (List.map (fun l -> h :: l) (powersetr t)) @ (powersetr t)

    let powerset (el: Set<'a>) =
        Set.toList el
        |> powersetr
        |> List.map Set.ofList
        |> Set.ofList

    let rec bfDoor st dir inv floor heavyCombs =
        match getAsciiMsg st with
        | Contains "lighter", newSt ->
            let drop = (new System.Random()).Next(Set.count inv)
            let dropped = Set.toList inv |> List.item drop

            let command =
                sprintf "drop %s\n%s" dropped dir
            bfDoor (feedAsciin command newSt) (Set.remove dropped inv) (Set.add dropped floor)
                (Set.add inv heavyCombs)
        | Contains "heavier", newSt ->
            let taken =
                Seq.unfold (fun () ->
                    Set.toList floor
                    |> List.item ((new System.Random()).Next(Set.count floor))
                    |> (fun v -> Some(v, ()))) ()
                |> Seq.find (fun tk ->
                    Set.add tk inv
                    |> powerset
                    |> rev Set.contains heavyCombs
                    |> (not))

            let command =
                sprintf "take %s\n%s" taken dir

            bfDoor (feedAsciin command newSt) (Set.add taken inv) (Set.remove taken floor) heavyCombs
        | msg, _ -> printfn "%s" msg

    let rec navigate expectation santabot =
            match getAsciiMsg santabot.botState with
            | NewRoom rm, newSt when rm = "Security Checkpoint" ->
                let weighDir = 
                bfDoor newSt ()
            | _, Halted ->
                match santabot.inventory with
                | baddie :: others -> navigate Room { santabot with
                    badItems = Set.add baddie santabot.badItems
                    inventory = others
                    botState = santabot.saveState }
