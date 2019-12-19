namespace AoC

module AStar =
    type AStarCollection<'a, 'b when 'b: comparison> = Map<'b, 'a list>

    type AStarList<'a, 'b, 'c when 'c: comparison and 'b: comparison> =
        { itemMap: AStarCollection<'a, 'b>
          previous: Set<'c>
          normalizer: 'a -> 'c
          scorer: 'a -> 'b }

    let minKey map = Map.tryPick (fun k _ -> Some(k)) map
    let rev f x y = f y x

    let findDefault def map key =
        Map.tryFind key map
        |> function
        | None -> def
        | Some(vl) -> vl

    let newList scoreFun normalFun =
        { itemMap = Map.empty
          previous = Set.empty
          normalizer = normalFun
          scorer = scoreFun }

    let add aList item =
        let { itemMap = iMap; previous = p; normalizer = n; scorer = f } = aList
        if Set.contains (n item) p then
            aList
        else
            { aList with
                  itemMap = Map.add (f item) (item :: (findDefault [] iMap (f item))) iMap
                  previous = Set.add (n item) p }

    // a more efficient version of List.map (add aList) items
    let addList aList items =
        let { itemMap = iMap; previous = p; normalizer = n; scorer = f } = aList
        { itemMap =
              items
              |> List.filter
                  (n
                   >> rev Set.contains p
                   >> (not))
              |> List.groupBy f
              |> List.fold (fun aMap (v, al) -> Map.add v (List.append al (findDefault [] aMap v)) aMap) iMap
          previous = List.fold (fun s i -> Set.add (n i) s) p items
          normalizer = n
          scorer = f }

    let pop aList =
        let { itemMap = iMap; previous = p; normalizer = n; scorer = f } = aList
        match minKey iMap with
        | None -> None
        | Some(mk) ->
            match Map.find mk iMap with
            | [] -> None
            | [ a ] -> Some(a, { aList with itemMap = Map.remove mk iMap })
            | a :: rest -> Some(a, { aList with itemMap = Map.add mk rest iMap })
 