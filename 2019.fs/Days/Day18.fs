namespace AoC

module Day19 =
    let input =
        Utils.getInputLines 18
        |> Array.map Array.ofSeq
        |> array2D

    let addTup (a, b) (x, y) = (a + x, b + y)
    let mDist (a, b) (x, y) = abs (a - x) + abs (b - y)
    let second (_, y) = y
    let lower (c: char) = char ((int c) + 32)
    let rev f x y = f y x

    let dirs =
        [ 1, 0
          0, 1
          -1, 0
          0, -1 ]

    let getFrontier (map: char [,]) loc keys =
        List.map (addTup loc) dirs
        |> List.filter (fun (i, j) ->
            let b = map.[i, j]
            b = '.' || b = '@' || (b <= 'z' && b >= 'a') || Set.contains (lower b) keys)

    let scorer keyIxs (loc, steps, keys) =
        (keyIxs
         |> Map.filter (fun k _ -> not (Set.contains k keys))
         |> Map.map (fun _ v -> mDist v loc)
         |> Map.toList
         |> List.unzip
         |> second
         |> (fun l ->
         if List.isEmpty l then [ 0 ]
         else l)
         |> List.min)
        + steps

    let findStart map =
        let mutable loc = (0, 0)
        Array2D.iteri (fun i j b ->
            if b = '@' then loc <- (i, j)) map
        loc

    let getKeyIxs map =
        let mutable keyixs = Map.empty
        Array2D.iteri (fun i j b ->
            if b <= 'z' && b >= 'a' then keyixs <- Map.add b (i, j) keyixs) map
        keyixs

    let makeNext (map: char [,]) steps keys loc =
        let (i, j) = loc
        let b = map.[i, j]
        (loc, steps + 1,
         (if b <= 'z' && b >= 'a' then Set.add b keys
          else keys))

    let rec aSearch map keyCt searchList =
        match AStar.pop searchList with
        | Some(ns, rest) ->
            let (loc, steps, keys) = ns
            if (Set.count keys) = keyCt then
                ns
            else
                let ft = getFrontier map loc keys |> List.map (makeNext map steps keys)
                aSearch map keyCt (AStar.addList rest ft)

        | None -> ((0, 0), 0, Set.empty)

    let norm (l, _, k) = (l, k)

    let silver input =
        let keyIxs = getKeyIxs input
        let sList = AStar.newList (scorer keyIxs) norm
        aSearch input (Map.count keyIxs) (AStar.add sList (findStart input, 0, Set.empty))

    let update map =
        let (x, y) = findStart map
        let mutable startPoints = []
        for i in [ (x - 1) .. (x + 1) ] do
            for j in [ (y - 1) .. (y + 1) ] do
                map.[i, j] <- '#'

        for i in [ (x - 1)
                   (x + 1) ] do
            for j in [ (y - 1)
                       (y + 1) ] do
                map.[i, j] <- '@'
                startPoints <- (i, j) :: startPoints

        map, startPoints

    let listSet n item list =
        List.mapi (fun i t ->
            if i = n then item
            else t) list

    let getMultiFrontier map locs keys =
        [ 0 .. 3 ]
        |> List.map (fun i -> getFrontier map (List.item i locs) keys |> List.map (fun t -> listSet i t locs, i))
        |> List.concat

    let makeNextMulti (map: char [,]) steps keys (locs, last) =
        let newKeys =
            List.fold (fun ks (i, j) ->
                let b = map.[i, j]
                if b <= 'z' && b >= 'a' then Set.add b ks
                else ks) keys locs
        (locs, steps + 1, newKeys, last)

    let rec aSearchMulti (map: char [,]) keyIxs searchList =
        match AStar.pop searchList with
        | Some(ns, rest) ->
            let (locs, steps, keys, last) = ns
            if (Set.count keys) = Map.count keyIxs then
                ns
            else
                let onKey =
                    let (i, j) = List.item (min last 3) locs
                    let b = map.[i, j]
                    b <= 'z' && b >= 'a'

                let ft =
                    if onKey || last = 4 then getMultiFrontier map locs keys
                    else getFrontier map (List.item last locs) keys |> List.map (fun t -> listSet last t locs, last)
                    |> List.map (makeNextMulti map steps keys)
                //printfn "%A" ft
                aSearchMulti map keyIxs (AStar.addList rest ft)
        | None -> ([ 0, 0 ], 0, Set.empty, 0)

    let scorerMulti keyIxs (locs, steps, keys, l) =
        (keyIxs
         |> Map.filter (fun k _ -> not (Set.contains k keys))
         |> Map.map (fun _ v -> List.map (mDist v) locs |> List.min)
         |> Map.toList
         |> List.unzip
         |> second
         |> (fun l ->
         if List.isEmpty l then [ 0 ]
         else l)
         |> List.min)
        + steps

    let normm (l, _, k, _) = l, k

    let gold input =
        let (nMap, starts) = update input
        let keyIxs = getKeyIxs nMap
        let sList = AStar.newList (scorerMulti keyIxs) normm
        aSearchMulti nMap keyIxs (AStar.add sList (starts, 0, Set.empty, 4))


    printfn "%A" (gold input)
