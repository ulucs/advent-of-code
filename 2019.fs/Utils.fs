namespace AoC

open FSharp.Data

module Utils =
    let sessionCookie = System.IO.File.ReadAllText("../session.cookie").Trim()
    let splitLines (text: string) = text.Split("\n") |> Array.filter ((=) "" >> (not))
    let trimString (text: string) = text.Trim()
    let bigint (x: int) = bigint x

    let cartesian xs ys = xs |> List.collect (fun x -> ys |> List.map (fun y -> (x, y)))

    let rec distribute e =
        function
        | [] -> [ [ e ] ]
        | x :: xs' as xs ->
            (e :: xs) :: [ for xs in distribute e xs' -> x :: xs ]

    let rec permute =
        function
        | [] -> [ [] ]
        | e :: xs -> List.collect (distribute e) (permute xs)

    let memoized (fn: 'a -> 'b) =
        let memo = new System.Collections.Generic.Dictionary<'a, 'b>()
        fun a ->
            match memo.TryGetValue(a) with
            | true, b -> b
            | _ ->
                let b = fn a
                memo.Add(a, b)
                b

    let (|Prefix|_|) (p: string) (s: string) =
        if s.StartsWith(p) then Some(s.Substring(p.Length)) else None

    let getInputRaw day =
        Http.RequestString
            (sprintf "https://adventofcode.com/2019/day/%d/input" day, cookies = [ "session", sessionCookie ])

    let getInput = getInputRaw >> trimString

    let getIntcode day = (getInput day).Split(",") |> Array.map (System.Numerics.BigInteger.Parse)

    let getInputLines day =
        getInput day
        |> splitLines
        |> Array.filter (fun a -> a.Length > 0)

    let postSolution day part answer =
        Http.RequestString
            (sprintf "https://adventofcode.com/2019/day/%d/answer" day, httpMethod = "POST",
             body = HttpRequestBody.TextRequest(sprintf "answer=%A&level=%d" answer part),
             cookies = [ "session", sessionCookie ])

    let getBigBoy path = System.IO.File.ReadAllLines(path) |> Array.filter (fun a -> a.Length > 0)
