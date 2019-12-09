namespace AoC

open OpcodeMachine

module Day7 =
    let input = (Utils.getInput 7).Split(",") |> Array.map int

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
            | 0 -> Some(Jump(fun _ -> true), 2)
            | _ -> None) []

    let combRunner input comb =
        let machines = [| 0 .. 4 |] |> Array.map (fun _ -> machinery input)
        let mutable loop = true

        for (i, m) in Array.indexed machines do
            match m with
            | Waiting(fn) -> Array.set machines i (fn (List.item i comb))

        match machines.[0] with
        | Waiting(fn) -> Array.set machines 0 (fn 0I)

        while loop do
            Array.tryFindIndex (function
                | Message(_, _) -> true
                | _ -> false) machines
            |> function
            | Some(i) ->
                match (machines.[i], machines.[(i + 1) % 5]) with
                | (Message(msg, st), Waiting(fn)) ->
                    Array.set machines ((i + 1) % 5) (fn msg)
                    Array.set machines i st
                | _ -> loop <- false
            | None -> loop <- false

        match Array.last machines with
        | Message(i, Halted) -> i

    let gold input =
        Utils.permute [ 5I .. 9I ]
        |> List.map (combRunner input)
        |> List.max

    gold input
    |> printf "%A\n"
