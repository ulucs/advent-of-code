namespace AoC

open Utils

#nowarn "25"

module Day5 =
    let input = (getInput 5).Split(",") |> Array.map int

    let b2i =
        function
        | true -> 1I
        | false -> 0I

    let silver =
        OpcodeMachine.build (function
            | 1 -> Some(OpcodeMachine.Write(fun (x :: (y :: _)) -> x + y), 3)
            | 2 -> Some(OpcodeMachine.Write(fun (x :: (y :: _)) -> x * y), 3)
            | 3 -> Some(OpcodeMachine.Write(fun _ -> 1I), 1)
            | 4 ->
                Some
                    (OpcodeMachine.Read
                        (List.head
                         >> printf "%d\n"), 1)
            | _ -> None) []

    let gold =
        OpcodeMachine.build (function
            | 1 -> Some(OpcodeMachine.Write(fun (x :: (y :: _)) -> x + y), 3)
            | 2 -> Some(OpcodeMachine.Write(fun (x :: (y :: _)) -> x * y), 3)
            | 3 -> Some(OpcodeMachine.Write(fun _ -> 5), 1)
            | 4 ->
                Some
                    (OpcodeMachine.Read
                        (List.head
                         >> printf "%d\n"), 1)
            | 5 -> Some(OpcodeMachine.Jump(fun (x :: _) -> x <> 0I), 2)
            | 6 -> Some(OpcodeMachine.Jump(fun (x :: _) -> x = 0I), 2)
            | 7 -> Some(OpcodeMachine.Write(fun (x :: (y :: _)) -> b2i (x < y)), 3)
            | 8 -> Some(OpcodeMachine.Write(fun (x :: (y :: _)) -> b2i (x = y)), 3)
            | _ -> None) []

    gold input |> ignore
