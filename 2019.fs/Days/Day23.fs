namespace AoC

open OpcodeMachine

module Day23 =
    let input = Utils.getIntcode 23
    let rev f x y = f y x

    let machines input =
        [ 0I .. 49I ]
        |> List.map (fun i ->
            match OpcodeMachine.build intructions [] input with
            | Waiting(f) -> f i)

    let feedMsg msg machine =
        match msg, machine with
        | (None, Waiting(f)) -> f -(1I)
        | (Some([ x; y ])), Waiting(f) ->
            match f x with
            | Waiting(f) -> f y
        | (_, s) ->
            printfn "%A" s
            Halted

    let withDefFind d k m =
        match Map.tryFind k m with
        | Some(v) -> v
        | None -> d

    let silver input =
        let mutable network = machines input
        let mutable natMsg = [ -1I; -1I ]
        let mutable msgQueue = Map.empty
        while true do
            let newMsgs, machines = List.map getMessages network |> List.unzip
            for l in newMsgs do
                match l with
                | [] -> ()
                | ll ->
                    for [ d; x; y ] in List.chunkBySize 3 ll do
                        if d = 255I then natMsg <- [ x; y ]
                        msgQueue <- Map.add d (List.append (withDefFind [] d msgQueue) [ [ x; y ] ]) msgQueue

            let heads = Map.map (fun _ v -> List.tryHead v) msgQueue

            if Map.forall (fun _ v -> v = None) heads && natMsg <> [-1I; -1I] then
                network <-
                    List.mapi (fun i m ->
                        if i = 0 then
                            printfn "%A" natMsg
                            let mm = feedMsg (Some(natMsg)) m
                            natMsg <- [-1I; -1I]
                            mm
                        else
                            m) machines
            else
                msgQueue <-
                    Map.map (fun _ v ->
                        match v with
                        | [] -> []
                        | a :: l -> l) msgQueue
                network <- List.mapi (fun i m -> feedMsg (withDefFind None (bigint i) heads) m) machines

    silver input
