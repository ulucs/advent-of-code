namespace AoC

open OpcodeMachine

module Day11 =
    let input = (Utils.getInput 11).Split(",") |> Array.map (fun i -> System.Numerics.BigInteger.Parse(i))

    type Color =
        | Black
        | White

    let toColor =
        int
        >> function
        | 0 -> Black
        | 1 -> White

    let ofColor =
        function
        | Black -> 0I
        | White -> 1I

    type Dirs =
        | Horizontal
        | Vertical

    type Turns =
        | Left
        | Right

    let toTurn =
        int
        >> function
        | 0 -> Left
        | 1 -> Right

    type Robot =
        { direction: Dirs * int
          location: int * int }

    let turn (d, v: int) t =
        match (d, t) with
        | (Horizontal, Left) -> (Vertical, -v)
        | (Horizontal, Right) -> (Vertical, v)
        | (Vertical, Left) -> (Horizontal, v)
        | (Vertical, Right) -> (Horizontal, -v)

    let findDefault (key: 'a) (map: Map<'a, Color>) =
        match Map.tryFind key map with
        | None -> Black
        | Some(i) -> i

    let paint canvas =
        let (ys, xs) =
            canvas
            |> Map.filter (fun x y -> y = White)
            |> Map.toList
            |> List.map (fun (x, y) -> x)
            |> List.unzip

        let xm = List.max xs
        let x_ = List.min xs
        let ym = List.max ys
        let y_ = List.min ys

        for i in [ ym .. -1 .. y_ ] do
            for j in [ x_ .. xm ] do
                (match Map.tryFind (i, j) canvas with
                 | Some(White) -> '#'
                 | _ -> ' ')
                |> printf "%c"
            printf "\n"

    let rMove canvas (paint: Color) dir robot =
        let (x, y) = robot.location
        let nd = turn robot.direction dir

        let newLoc =
            match nd with
            | (Horizontal, i) -> (x, y + i)
            | (Vertical, i) -> (x - i, y)

        let newRobo =
            { direction = nd
              location = newLoc }

        Map.add robot.location paint canvas, newRobo

    let rec roboLoop messages canvas robo =
        match messages with
        | Message(pt, Message(trn, st)) ->
            match rMove canvas (toColor pt) (toTurn trn) robo with
            | (canvasM, roboM) -> roboLoop st canvasM roboM
        | Waiting(cont) ->
            roboLoop
                (findDefault robo.location canvas
                 |> ofColor
                 |> cont) canvas robo
        | Halted -> canvas


    let silver input =
        let robo =
            { direction = (Vertical, -1)
              location = (0, 0) }

        let machine = OpcodeMachine.build intructions [] input

        roboLoop machine Map.empty robo |> Map.count

    let gold input =
        let robo =
            { direction = (Vertical, -1)
              location = (0, 0) }

        let machine = OpcodeMachine.build intructions [] input

        roboLoop machine (Map.ofList [ (0, 0), White ]) robo |> paint


    silver input
    |> printf "%d\n"

    gold input
