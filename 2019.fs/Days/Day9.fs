namespace AoC

open OpcodeMachine

module Day9 =
    let input = (Utils.getInput 9).Split(",") |> Array.map int

    let ti = "104,11258924,99".Split(",") |> Array.map int

    let b2i =
        function
        | true -> 1I
        | false -> 0I

    let machinery =
        OpcodeMachine.build (function
            | 1 -> Some(Write(fun (x :: (y :: _)) -> x + y), 3)
            | 2 -> Some(Write(fun (x :: (y :: _)) -> x * y), 3)
            | 3 -> Some(Receive, 1)
            | 4 -> Some(Send, 1)
            | 5 -> Some(Jump(fun (x :: _) -> x <> 0I), 2)
            | 6 -> Some(Jump(fun (x :: _) -> x = 0I), 2)
            | 7 -> Some(Write(fun (x :: (y :: _)) -> b2i (x < y)), 3)
            | 8 -> Some(Write(fun (x :: (y :: _)) -> b2i (x = y)), 3)
            | 9 -> Some(SetBase, 1)
            | _ -> None) []

    let silver input =
        match machinery input with
        | Waiting(fn) -> fn 1I
        | i -> i

    let gold input =
        match machinery input with
        | Waiting(fn) -> fn 2I
        | i -> i

    gold input
    |> printf "%A\n"
