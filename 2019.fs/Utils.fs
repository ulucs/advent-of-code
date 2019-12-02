namespace AoC

open FSharp.Data

module Utils =
    let splitLines (text: string) = text.Split("\n")

    let getInputLines day =
        Http.RequestString
            (sprintf "https://adventofcode.com/2019/day/%d/input" day,
             cookies =
                 [ "session",
                   "***REMOVED***" ])
        |> splitLines
        |> Array.filter (fun a -> a.Length > 0)
