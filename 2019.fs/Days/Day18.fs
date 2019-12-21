namespace AoC

module Day19 =
    let input =
        Utils.getInputLines 18
        |> Array.map Array.ofSeq
        |> array2D

    let addTup (a, b) (x, y) = (a + x, b + y)
    let mDist (a, b) (x, y) = abs (a - x) + abs (b - y)
    let second (_, y) = y
    let second3 (_, y, _) = y
    let firstThird (x, _, z) = x, z
    let lower (c: char) = char ((int c) + 32)
    let upper (c: char) = char ((int c) - 32)
    let rev f x y = f y x
    let uniq = Set.ofList >> Set.toList

    let listSet i it =
        List.mapi (fun j k ->
            if i = j then it
            else k)

    let dirs =
        [ 1, 0
          0, 1
          -1, 0
          0, -1 ]

    type SearchStep = char * (int * int) * int * Set<char>

    type SearchPoint =
        | Halfway of char * (int * int) * int * Set<char>
        | Final of char * char * (int * int) * int * Set<char>

    let update (map: char [,]) =
        let x, y = 40, 40
        for i in [ (x - 1) .. (x + 1) ] do
            for j in [ (y - 1) .. (y + 1) ] do
                map.[i, j] <- '#'

        for a, i in List.indexed
                        [ (x - 1)
                          (x + 1) ] do
            for b, j in List.indexed
                            [ (y - 1)
                              (y + 1) ] do
                map.[i, j] <- char (2 * a + b + 48)

        map


    let getNear (map: char [,]) =
        function
        | Halfway(begi, loc, steps, reqs) ->
            List.map (addTup loc) dirs
            |> List.filter (fun (i, j) -> map.[i, j] <> '#')
            |> List.map (fun (i, j) ->
                let b = map.[i, j]
                if b >= 'A' && b <= 'Z' then Halfway(begi, (i, j), steps + 1, Set.add b reqs)
                else if b >= 'a' && b <= 'z' then Final(b, begi, (i, j), steps + 1, reqs)
                else Halfway(begi, (i, j), steps + 1, reqs))
        | _ -> []

    let withDefault def =
        function
        | Some(i) -> i
        | None -> def

    let normPaths =
        function
        | Halfway(begi, loc, steps, recs) -> begi, loc
        | Final(_, begi, loc, _, _) -> begi, loc

    let ftohalf =
        function
        | Final(_, b, l, s, r) -> Halfway(b, l, s, r)
        | i -> i

    let rec mapPathsWithReqs map paths frontier seen =
        let roadmap =
            List.map (getNear map) frontier
            |> List.concat
            |> List.filter
                (normPaths
                 >> rev Set.contains seen
                 >> (not))
            |> List.groupBy (function
                | Halfway(_) -> 'h'
                | Final(_) -> 'f')
            |> Map.ofList

        let finals = Map.tryFind 'f' roadmap |> withDefault []

        let newPaths =
            List.fold (fun pths k ->
                match k with
                | Final(ed, f, _, s, reqs) ->
                    let m1 = Map.tryFind f pths |> withDefault Map.empty
                    let l1 = (s, reqs) :: (Map.tryFind ed m1 |> withDefault [])
                    Map.add f (Map.add ed (uniq l1) m1) pths
                | _ -> pths) paths finals

        match Map.tryFind 'h' roadmap with
        | None -> newPaths
        | Some(l) ->
            let nl = List.append l (List.map ftohalf finals)

            let newSeen =
                List.map normPaths nl
                |> Set.ofList
                |> Set.union seen

            mapPathsWithReqs map newPaths nl newSeen

    let initMapping map =
        let mutable starts = []
        Array2D.iteri
            (fun i j b ->
            if b = '@' || (b >= 'a' && b <= 'z') || (b >= '0' && b <= '3') then
                starts <- Halfway(b, (i, j), 0, Set.empty) :: starts) map

        mapPathsWithReqs map Map.empty starts (List.map normPaths starts |> Set.ofList)

    let getFrontier paths (loc, step, keys) =
        Map.find loc paths
        |> Map.toList
        |> List.map (fun (nk, lines) -> List.map (fun (dsts, reqs) -> (nk, dsts, reqs)) lines)
        |> List.concat
        |> List.filter (fun (nk, _, _) -> Set.contains nk keys |> (not))
        |> List.filter (fun (_, _, reqs) -> Set.difference (Set.map lower reqs) keys |> Set.isEmpty)
        |> List.map (fun (nk, dsts, _) -> (nk, step + dsts, Set.add nk keys))

    let rec exploreSilver paths finalSum alist =
        match AStar.pop alist with
        | None -> 0
        | Some((loc, steps, keys), rest) ->
            if Set.count keys = finalSum then steps
            else exploreSilver paths finalSum (AStar.addList rest (getFrontier paths (loc, steps, keys)))

    let silver input =
        let paths = initMapping input
        let alist = AStar.newList second3 firstThird
        exploreSilver paths 26 (AStar.add alist ('@', 0, Set.empty))

    let mergeFront i locs (nl, s, k) = (listSet i nl locs, s, k)

    let rec exploreGold paths finalSum alist =
        match AStar.pop alist with
        | None -> 0
        | Some((locs, steps, keys), rest) ->
            if Set.count keys = finalSum then
                steps
            else
                List.mapi (fun i l -> getFrontier paths (l, steps, keys), i) locs
                |> List.map (fun (fl, i) -> List.map (mergeFront i locs) fl)
                |> List.concat
                |> AStar.addList rest
                |> exploreGold paths finalSum

    let gold input =
        let nmap = update input
        let paths = initMapping nmap
        let alist = AStar.newList second3 firstThird
        exploreGold paths 26 (AStar.add alist ([ '0'; '1'; '2'; '3' ], 0, Set.empty))

    printfn "%A" (gold input)
