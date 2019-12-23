namespace AoC

open System.Text.RegularExpressions

module Day22 =
    type Shuffle =
        | Stack
        | Increment of bigint
        | Cut of bigint

    let (|Contains|_|) (smp: string) (str: string) =
        if str.Contains(smp) then Some(str) else None

    let i2bi (i: int) = bigint i
    let getInt str = Regex.Match(str, "-?[0-9]+").Value |> (int >> bigint)
    let second (_, y) = y
    let rTup (x, y) = y, x

    let printd x =
        printfn "%A" x
        x

    let parseIn =
        function
        | Contains "stack" _ -> Stack
        | Contains "increment" s -> Increment(getInt s)
        | Contains "cut" s -> Cut(getInt s)

    let input = Utils.getInputLines 22 |> Array.map parseIn

    let mapvals f = Map.map (fun _ v -> f v)
    let rev f x y = f y x

    let shuffle dl style deck =
        match style with
        | Stack -> mapvals ((-) (dl - 1I)) deck
        | Increment(i) -> mapvals ((*) i >> rev (%) dl) deck
        | Cut(i) -> mapvals ((+) (-i + dl) >> rev (%) dl) deck

    let rec moddiv m d v =
        if v % d = 0I then v / d else moddiv m d (v + m)

    let shuffleInv dl style deck =
        match style with
        | Stack -> mapvals ((-) (dl - 1I)) deck
        | Increment(i) -> mapvals (moddiv dl i) deck
        | Cut(i) -> mapvals ((+) (i + dl) >> rev (%) dl) deck

    let deckify = List.map (fun i -> i, i) >> Map.ofList
    let makeDeck i = deckify [ 0I .. (i - 1I) ]

    let silver input =
        input
        |> Array.map (shuffle 10007I)
        |> Array.reduce (>>)
        <| (makeDeck 10007I)
        |> Map.find 2019I

    let mapconcat m1 m2 = List.append (Map.toList m1) (Map.toList m2) |> Map.ofList

    let Ntimes sq succ n =
        List.unfold (fun l ->
            if l = 0I then None
            else if l = 2I then Some(succ >> succ, 0I)
            else if l % 2I = 0I then Some(sq, l / 2I)
            else Some(succ, l - 1I)) n
        |> List.reduce (<<)

    let expnim (i: bigint) j m = Ntimes (fun i -> (i ** 2) % m) ((*) -i) j <| 1I

    let rec rrmod p0 p1 (x: bigint) y m =
        if y % x = 0I
        then p1
        else rrmod p1 ((p0 - p1 * (y / x)) % m) (y % x) x m

    let rmod x m = rrmod 0I 1I x m m

    let goldF input =
        input
        |> Array.map (shuffleInv 119315717514047I)
        |> Array.reduce (<<)
        <| deckify [ 0I .. 100I ]
        |> Map.toList

    let gold t =
        let a = 29205896113488I
        let b = 119199174489885I
        let m = 119315717514047I

        let im i = ((expnim a i m) * 2020I + b * (1I - (expnim a i m)) * (rmod (1I + a) m)) % m
        im t

    printfn "%A" (gold 101741582076661I)
