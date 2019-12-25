namespace AoC

open Utils

module Day24 =
    let input =
        Utils.getInputLines 24
        |> Array.map (Array.ofSeq)
        |> Array.mapi (fun i l ->
            Array.mapi (fun j c ->
                ((i, j),
                 (if c = '.' then 0 else 1))) l)
        |> Array.concat
        |> Map.ofArray

    let findWithDef d k m =
        match Map.tryFind k m with
        | None -> d
        | Some(v) -> v

    let rev f x y = f y x
    let second (_, y) = y
    let first (x, _) = x

    let dirs =
        [ 1, 0
          0, 1
          -1, 0
          0, -1 ]

    let finds keyL map = List.map (rev (findWithDef 0) map) keyL

    let addTup (a, b) (x, y) = (a + x, b + y)

    let diversify bugMap =
        Map.map (fun loc alive ->
            let nSum =
                List.map (addTup loc) dirs
                |> rev finds bugMap
                |> List.reduce (+)

            match nSum, alive with
            | 1, 1
            | 1, 0
            | 2, 0 -> 1
            | _ -> 0) bugMap

    let loc2lx (i, j) = i * 5 + j

    let countDvs bugMapOp =
        Map.toList bugMapOp
        |> List.map (fun (l, a: int) -> 2I ** (loc2lx l) * (bigint a))
        |> List.sum

    let silver input =
        Seq.unfold (fun (bugs, reps) ->
            let next = diversify bugs

            let out =
                if Set.contains next reps then Some(next) else None
            Some(out, (next, Set.add next reps))) (input, Set.empty)
        |> Seq.find ((<>) None)
        |> (fun x -> countDvs (x.Value))

    let touchesInner l = l = (1, 2) || l = (2, 1) || l = (2, 3) || l = (3, 2)
    let touchesOuter (x, y) = x = 0 || x = 4 || y = 0 || y = 4

    let countFromIn (x, y) outer =
        if x = 0 then Map.find (1, 2) outer else 0 + if x = 4 then Map.find (3, 2) outer else 0
        + if y = 0 then Map.find (2, 1) outer else 0
        + if y = 4 then Map.find (2, 3) outer else 0

    let countFromOut loc inner =
        match loc with
        | 1, 2 -> cartesian [0] [ 0 .. 4 ]
        | 3, 2 -> cartesian [4] [ 0 .. 4 ]
        | 2, 1 -> cartesian [ 0 .. 4 ] [0]
        | 2, 3 -> cartesian [ 0 .. 4 ] 4[]]
        |> rev finds inner
        |> List.sum

    let zMap =
        cartesian [ 0 .. 4 ] [ 0 .. 4 ]
        |> List.map (fun i -> i, 0)
        |> Map.ofList

    let recDiversify map inner outer =
        Map.map (fun loc alive ->
            let nSum =
                (List.map (addTup loc) dirs
                 |> rev finds map
                 |> List.reduce (+)) + (if touchesInner loc then countFromOut loc inner else 0)
                + (if touchesOuter loc then countFromIn loc outer else 0)

            match nSum, alive with
            | 1, 1
            | 1, 0
            | 2, 0 -> 1
            | _ -> 0) map

    let hasLife f m =
        Map.filter (fun l _ -> f l) m
        |> Map.toList
        |> List.map second
        |> List.sum
        |> (<>) 0

    let printFauna depth bmap =
        printfn "Depth: %A\n" depth
        Map.iter (fun (_, y) a ->
            printf "%c" (if a = 1 then '#' else '.')
            if y = 4 then printfn "") bmap
        printfn ""
        bmap

    let gold input =
        Seq.unfold (fun (i, rbm) ->
            if i >= 200 then
                None
            else
                let xk, nk =
                    Map.toList rbm
                    |> List.map first
                    |> (fun l -> List.max l, List.min l)

                let nMap =
                    (if Map.find nk rbm |> hasLife touchesInner
                     then Map.add (nk - 1) zMap rbm
                     else rbm)
                    |> (fun rbm2 ->
                        if Map.find xk rbm2 |> hasLife touchesOuter
                        then Map.add (xk + 1) zMap rbm2
                        else rbm2)
                    |> Map.map (fun lv bmap ->
                        let inner = findWithDef zMap (lv - 1) rbm
                        let outer = findWithDef zMap (lv + 1) rbm
                        recDiversify bmap inner outer |> Map.add (2, 2) 0)

                Some(nMap, (i + 1, nMap))) (0, [ 0, input ] |> Map.ofList)
        |> Seq.last
        |> Map.toList
        |> List.map second
        |> List.map (Map.toList >> List.map second)
        |> List.concat
        |> List.sum

    printfn "%A" (gold input)
