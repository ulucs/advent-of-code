namespace AoC

open OpcodeMachine
open System.Numerics

module Day17 =
    let input = Utils.getIntcode 17
    let first (x, y) = x
    let second (x, y) = y
    let rev f x y = f y x

    let (|In|_|) clist c =
        if List.contains c clist then Some()
        else None

    let camera = OpcodeMachine.build intructions []
    let robo = OpcodeMachine.build intructions [ 0, 2I ]

    let checkIntersection (i, j) map =
        [ (i, j)
          (i + 1, j)
          (i - 1, j)
          (i, j + 1)
          (i, j - 1) ]
        |> List.map (rev Map.containsKey map)
        |> List.reduce (&&)

    let getMap input =
        camera input
        |> getMessages
        |> List.map int
        |> List.fold (fun (map, (row, col)) char ->
            match char with
            | In [ 35; 60; 62; 94; 118 ] -> (Map.add (row, col) char map, (row, col + 1))
            | 10 -> (map, (row + 1, 0))
            | _ -> (map, (row, col + 1))) (Map.empty, (0, 0))
        |> first

    let printMap input =
        camera input
        |> getMessages
        |> Array.ofList
        |> Array.map (int >> char)
        |> System.String
        |> printfn "%s"

    let silver input =
        let map = getMap input
        Map.map (fun (x, y) v ->
            if checkIntersection (x, y) map then x * y
            else 0) map
        |> Map.toList
        |> List.unzip
        |> second
        |> List.sum

    let rec feedRobo robo list =
        match list with
        | [] -> robo
        | hh :: tt ->
            match robo with
            | Message(_, r) -> feedRobo r list
            | Waiting(f) -> feedRobo (f hh) tt
            | _ -> robo

    let feedRoboS listS robo =
        List.ofSeq listS
        |> List.map (int >> bigint)
        |> feedRobo robo

    let gold input =
        let robot = robo input

        robot
        |> feedRoboS "A,A,B,C,A,C,B,C,A,B\n"
        |> feedRoboS "L,4,L,10,L,6\n"
        |> feedRoboS "L,6,L,4,R,8,R,8\n"
        |> feedRoboS "L,6,R,8,L,10,L,8,L,8\n"
        |> feedRoboS "n\n"
        |> getMessages
        |> List.last

    printfn "%A" (silver input)
    printfn "%A" (gold input)
