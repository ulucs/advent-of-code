namespace AoC

module OpcodeMachine =
    let getElemsTw indexes (array: int []) =
        seq {
            for i in indexes -> array.[array.[i]]
        }

    let rec exec getInstruction (input: int []) pos =
        let iLen = Array.length input
        let runner = exec getInstruction

        let code = getInstruction input.[pos]
        match code with
        | Some (op, argCount) f ->
            Array.set input input.[pos + argCount] (f (getElemsTw [ (pos + 1) .. (pos + argCount - 1) ] input))
            runner input ((pos + argCount + 1) % iLen)
        | None -> input

    let build getInstruction editList (input: int []) =
        let inp = Array.copy input
        for (pos, value) in editList do
            Array.set inp pos value
        exec getInstruction inp 0
