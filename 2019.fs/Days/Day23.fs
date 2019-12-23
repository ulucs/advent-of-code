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

    let withDefFind d k m =
        match Map.tryFind k m with
        | Some(v) -> v
        | None -> d

    let msgFromQueue queue =
        let q = Map.filter (fun _ v -> List.isEmpty v |> not) queue
        Map.map (fun _ v -> List.head v) q, Map.map (fun _ v -> List.tail v) q

    let queueMsgs msgs queue =
        List.concat msgs
        |> List.chunkBySize 3
        |> List.fold (fun q [ d; x; y ] -> Map.add d (List.append (withDefFind [] d q) [ [ x; y ] ]) q) queue

    let silver input =
        Seq.unfold (fun (msgQueue, network) ->
            let newMsgs, machines = List.map getMessages network |> List.unzip
            let newQ = queueMsgs newMsgs msgQueue
            let qh, qt = msgFromQueue newQ
            let newNet = List.mapi (fun i m -> withDefFind [ -(1I) ] (bigint i) qh |> feedRobo m) machines

            Some(qh, (qt, newNet))) (Map.empty, machines input)
        |> Seq.pick (Map.tryFind 255I)

    let gold input =
        let nat0 =
            [ -(1I)
              -(1I) ]
        Seq.unfold (fun (msgQueue, network, nat) ->
            let newMsgs, machines = List.map getMessages network |> List.unzip
            let newQ = queueMsgs newMsgs msgQueue
            let qh, qt = msgFromQueue newQ
            let natPass = Map.empty = qh && nat <> nat0

            let qn, nnat, passedVal =
                if natPass
                then ([ 0I, nat ] |> Map.ofList), nat0, Some(nat)
                else qh, withDefFind nat 255I qh, None

            let newNet = List.mapi (fun i m -> withDefFind [ -(1I) ] (bigint i) qn |> feedRobo m) machines
            Some(passedVal, (qt, newNet, nnat))) (Map.empty, machines input, nat0)
        |> Seq.filter ((<>) None)
        |> Seq.map (fun v -> v.Value)
        |> Seq.windowed 2
        |> Seq.find (fun [| [ _; y1 ]; [ _; y2 ] |] -> y1 = y2)

    printfn "%A" (silver input)
    printfn "%A" (gold input)
