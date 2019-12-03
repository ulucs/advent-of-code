namespace AoC

open FSharp.Data

module Utils =
    let splitLines (text: string) = text.Split("\n")
    let trimString (text: string) = text.Trim()

    let cartesian xs ys = xs |> List.collect (fun x -> ys |> List.map (fun y -> (x, y)))

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

    let postSolution day part answer =
        Http.RequestString
            (sprintf "https://adventofcode.com/2019/day/%d/answer" day, httpMethod = "POST",
             body = HttpRequestBody.TextRequest(sprintf "answer=%A&level=%d" answer part),
             cookies =
                 [ "session",
                   "***REMOVED***" ])

    let getBigBoy path = System.IO.File.ReadAllLines(path) |> Array.filter (fun a -> a.Length > 0)
