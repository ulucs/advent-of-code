namespace AoC

module OpcodeMachine =
    type Mode =
        | Immediate
        | Parameter

    type InstructionType<'a> =
        | Write of f: ('a list -> 'a)
        | Read of f: ('a list -> unit)
        | Jump of f: ('a list -> bool)

    let getElemsTw modes indexes (array: int []) =
        let iModes =
            modes
            |> List.take (List.length indexes)
            |> List.zip indexes

        seq {
            for (i, mode) in iModes ->
                array.[match mode with
                       | Parameter -> array.[i]
                       | Immediate -> i]
        }
        |> List.ofSeq


    let rec exec getInstruction (input: int []) pos =
        let iLen = Array.length input
        let runner = exec getInstruction

        match getInstruction (input.[pos] % 100) with
        | Some(op, argCount) ->
            let modes =
                (input.[pos] / 100).ToString()
                |> List.ofSeq
                |> List.map (string >> int)
                |> List.append [ 0; 0; 0; 0; 0 ]
                |> List.rev
                |> List.map (function
                    | 0 -> Parameter
                    | 1 -> Immediate
                    | _ -> Parameter)

            let ixs = [ (pos + 1) .. (pos + argCount) ]
            let funcIns = getElemsTw modes ixs input
            match op with
            | Write(f) ->
                Array.set input input.[pos + argCount] (f funcIns)
                runner input ((pos + argCount + 1) % iLen)
            | Read(f) ->
                f funcIns
                runner input ((pos + argCount + 1) % iLen)
            | Jump(f) ->
                match f funcIns with
                | true -> runner input (List.last funcIns)
                | false -> runner input ((pos + argCount + 1) % iLen)

        | None -> input

    let build getInstruction editList (input: int []) =
        let inp = Array.copy input
        for (pos, value) in editList do
            Array.set inp pos value
        exec getInstruction inp 0
