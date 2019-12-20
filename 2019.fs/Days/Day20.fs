namespace AoC

module Day20 =
    let input =
        Utils.getInputRaw 20
        |> Utils.splitLines
        |> Array.map Array.ofSeq
        |> array2D

    let addTup (a, b) (x, y) = (a + x, b + y)
    let mTup a (x, y) = (a * x, a * y)
    let first (x, _) = x
    let firstTwo (x, y, _) = x, y
    let second (_, y) = y
    let third (_, _, z) = z
    let rev f x y = f y x

    let isInner (x, y) = x >= 30 && y >= 30 && y <= 105 && x <= 105

    let (|Letter|_|) char =
        if char <= 'Z' && char >= 'A' then Some(char)
        else None

    let dirs =
        [ 1, 0
          0, 1
          -1, 0
          0, -1 ]

    let setTeleports map recurse =
        let mutable tlist = Map.empty
        Array2D.iteri (fun i j k ->
            let triples =
                List.map (fun dir ->
                    [ i, j
                      addTup dir (i, j)
                      addTup (mTup 2 dir) (i, j) ])
                    [ 1, 0
                      0, 1 ]
            for trp in triples do
                let dLv =
                    if not recurse then 0
                    else if isInner (List.item 0 trp) then 1
                    else -1

                let chars =
                    (List.map (fun (i, j) ->
                        try
                            Array2D.get map i j
                        with _ -> ' ')) trp

                match chars with
                | [ Letter(a); Letter(b); '.' ] -> tlist <- Map.add ((List.item 2 trp), dLv) (a, b) tlist
                | [ '.'; Letter(a); Letter(b) ] -> tlist <- Map.add ((List.item 0 trp), dLv) (a, b) tlist
                | _ -> ()) map

        tlist,
        (Map.toList tlist
         |> List.groupBy second
         |> List.unzip
         |> second
         |> List.map (List.unzip >> first)
         |> List.fold (fun adjs locs ->
             match locs with
             | [ (l1, d1); (l2, d2) ] -> Map.add l1 (l2, d1) adjs |> Map.add l2 (l1, d2)
             | _ -> adjs) Map.empty)

    let getFrontier (map: char [,]) teles (loc, lv, steps) =
        let its =
            List.map (addTup loc) dirs
            |> List.filter (fun (i, j) -> map.[i, j] = '.')
            |> List.map (fun l -> (l, lv, steps + 1))

        match Map.tryFind loc teles with
        | Some(l, dl) ->
            if lv + dl >= 0 then (l, lv + dl, steps + 1) :: its
            else its
        | None -> its

    let rec bsearch map teles final alist =
        match AStar.pop alist with
        | None -> 0
        | Some((l, lv, s), rest) ->
            if (l, lv) = final then s
            else bsearch map teles final (AStar.addList rest (getFrontier map teles (l, lv, s)))

    let solve input recursive =
        let alist = AStar.newList third firstTwo
        let tlist, portals = setTeleports input recursive
        let (start, _) = Map.findKey (fun _ v -> v = ('A', 'A')) tlist
        let (final, _) = Map.findKey (fun _ v -> v = ('Z', 'Z')) tlist

        bsearch input portals (final, 0) (AStar.add alist (start, 0, 0))

    printfn "%A" (solve input false)
    printfn "%A" (solve input true)
