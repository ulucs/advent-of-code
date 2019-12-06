namespace AoC

module Day6 =
    type Planet = Planet of string

    let (|Orbit|_|) (s: string) =
        match s.IndexOf(")") with
        | -1 -> None
        | i -> Some(s.Substring(0, i).Trim(), s.Substring(i + 1).Trim())

    type ListType =
        | Moons
        | Combined

    let input lt =
        Utils.getInputLines 6
        |> Array.map (function
            | Orbit(p, m) ->
                match lt with
                | Combined ->
                    [| (Planet(m), Planet(p))
                       (Planet(p), Planet(m)) |]
                | Moons -> [| (Planet(p), Planet(m)) |])
        |> Array.concat
        |> Array.fold (fun dt (p, m) ->
            match (Map.tryFind p dt) with
            | None -> Map.add p [ m ] dt
            | Some(ms) -> Map.add p (List.Cons(m, ms)) dt) Map.empty

    let moonList = input Moons
    let moveList = input Combined

    let rec countMoons moonList (k: Planet) =
        Map.tryFind k moonList
        |> function
        | None -> 0
        | Some(p) -> (List.length p) + List.sum (List.map (countMoons moonList) p)

    let silver input =
        input
        |> Map.map (fun k _ -> countMoons input k)
        |> Map.fold (fun acc _ v -> acc + v) 0

    let findDefault def map key =
        Map.tryFind key map
        |> function
        | None -> def
        | Some(vl) -> vl

    let rec pathfind moveList searchItem seen posList dist =
        let neighbors =
            posList
            |> List.ofSeq
            |> List.map (findDefault [] moveList)
            |> List.concat
            |> Set.ofList
            |> Set.difference
            <| seen

        if (Set.contains searchItem neighbors) then dist + 1
        else pathfind moveList searchItem (Set.union seen neighbors) neighbors (dist + 1)

    let gold start en = pathfind moveList (Planet(start)) Set.empty (Set.ofList [ Planet(en) ]) -2

    printf "%d\n" (silver moonList)
    printf "%d\n" (gold "YOU" "SAN")
