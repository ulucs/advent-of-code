namespace AoC

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

    let dprint code x z =
        if x = code then
            printf "%A\n" z

    let (|Equals|_|) arg x =
        if (arg = x) then Some()
        else None


    let i2bi (i: int) = bigint (i)

    let getFromMem ix mem =
        match Map.tryFind ix mem with
        | None -> 0I
        | Some(i) -> i

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

    let build getInstruction editList (input: int []) =
        let inp =
            input
            |> Array.indexed
            |> Map.ofArray

        let inp2 =
            editList
            |> List.fold (fun map (p, v) -> Map.add p v map) inp
            |> Map.map (fun k v -> bigint (v))

        exec getInstruction 0 0 inp2
