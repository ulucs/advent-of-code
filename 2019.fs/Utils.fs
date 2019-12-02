namespace AoC

open FSharp.Data

module Utils =
    let splitLines (text: string) = text.Split("\n")
    let trimString (text: string) = text.Trim()

    let getInput day =
        Http.RequestString
            (sprintf "https://adventofcode.com/2019/day/%d/input" day,
             cookies =
                 [ "session",
                   "***REMOVED***" ])
        |> trimString


    let getInputLines day =
        getInput day
        |> splitLines
        |> Array.filter (fun a -> a.Length > 0)
