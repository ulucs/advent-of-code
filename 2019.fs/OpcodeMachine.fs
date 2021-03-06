namespace AoC

#nowarn "25"

module OpcodeMachine =
    type Mode =
        | Immediate
        | Parameter
        | Relative of int

    type Status<'a> =
        | Halted
        | Waiting of ('a -> Status<'a>)
        | Message of 'a * Status<'a>

    type InstructionType<'a> =
        | SetBase
        | Receive
        | Write of operator: ('a list -> 'a)
        | Send
        | Jump of evaluate: ('a list -> bool)

    let b2i =
        function
        | true -> 1I
        | false -> 0I

    let intructions =
        function
        | 1 -> Some(Write(fun (x :: (y :: _)) -> x + y), 3)
        | 2 -> Some(Write(fun (x :: (y :: _)) -> x * y), 3)
        | 3 -> Some(Receive, 1)
        | 4 -> Some(Send, 1)
        | 5 -> Some(Jump(fun (x :: _) -> x <> 0I), 2)
        | 6 -> Some(Jump(fun (x :: _) -> x = 0I), 2)
        | 7 -> Some(Write(fun (x :: (y :: _)) -> b2i (x < y)), 3)
        | 8 -> Some(Write(fun (x :: (y :: _)) -> b2i (x = y)), 3)
        | 9 -> Some(SetBase, 1)
        | 0 -> Some(Jump(fun _ -> true), 2)
        | 99 -> None

    let dprint code x z =
        if x = code then
            printf "%A\n" z

    let (|Equals|_|) arg x =
        if (arg = x) then Some()
        else None

    let i2bi (i: int) = bigint i
    let bi2i (i: bigint) = int i

    let rec getMessagesAndStatus st list =
        match st with
        | Message(a, rest) -> getMessagesAndStatus rest (a :: list)
        | _ -> (List.rev list), st

    let getMessages st =
        getMessagesAndStatus st []

    let getAsciiMsg st =
        let msg, newSt = getMessages st
        (List.map (bi2i >> char) msg |> Array.ofList |> System.String), newSt

    let getFromMem ix mem =
        match Map.tryFind ix mem with
        | None -> 0I
        | Some(i) -> i

    let rec feedRobo robo list =
        match list with
        | [] -> robo
        | hh :: tt ->
            match robo with
            | Message(_, r) -> feedRobo r list
            | Waiting(f) -> feedRobo (f hh) tt
            | _ -> robo

    let feedAscii (str: seq<char>) robo =
        List.ofSeq str
        |> List.map (int >> bigint)
        |> feedRobo robo

    let feedAsciin (str: seq<char>) robo =
        feedAscii (Seq.append str "\n") robo

    let getPositions modes indexes (array: Map<int, bigint>) =
        let iModes =
            modes
            |> List.take (List.length indexes)
            |> List.zip indexes

        seq {
            for (i, mode) in iModes ->
                match mode with
                | Parameter -> getFromMem i array |> int
                | Immediate -> i
                | Relative(rb) -> rb + ((getFromMem i array) |> int)
        }
        |> List.ofSeq
        |> List.map int

    let getElements indexes (array: Map<int, bigint>) =
        seq {
            for ix in indexes -> getFromMem ix array
        }
        |> List.ofSeq

    let rec exec getInstruction rbase pos (input: Map<int, bigint>) =
        let iLen = Map.count input
        let operator = getFromMem pos input

        match getInstruction (operator % 100I |> int) with
        | Some(op, argCount) ->
            let modes =
                (operator / 100I).ToString()
                |> List.ofSeq
                |> List.map (string >> int)
                |> List.append [ 0; 0; 0; 0; 0 ]
                |> List.rev
                |> List.map (function
                    | 0 -> Parameter
                    | 1 -> Immediate
                    | 2 -> Relative(rbase)
                    | _ -> Parameter)

            let ixs = [ (pos + 1) .. (pos + argCount) ]
            let positions = getPositions modes ixs input
            let funcIns = getElements positions input
            let writePos = List.last positions

            match op with
            | SetBase -> exec getInstruction (rbase + (int (List.last funcIns))) (pos + argCount + 1) input
            | Receive ->
                Waiting(fun msg -> Map.add writePos msg input |> exec getInstruction rbase (pos + argCount + 1))
            | Write(f) -> Map.add writePos (f funcIns) input |> exec getInstruction rbase (pos + argCount + 1)
            | Send -> Message(List.head funcIns, exec getInstruction rbase (pos + argCount + 1) input)
            | Jump(f) ->
                match f funcIns with
                | true -> exec getInstruction rbase (int (List.last funcIns)) input
                | false -> exec getInstruction rbase (pos + argCount + 1) input

        | None -> Halted

    let build getInstruction editList (input: bigint []) =
        let inp = Array.copy input

        for (i, j) in editList do
            Array.set inp i j

        let inMap =
            inp
            |> Array.indexed
            |> Map.ofArray

        exec getInstruction 0 0 inMap
