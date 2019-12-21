namespace AoC

module AStar =
    type AStarCollection<'a, 'b when 'b: comparison> = Map<'b, 'a list>

    type AStarList<'a, 'b, 'c when 'c: comparison and 'b: comparison> =
        { itemMap: AStarCollection<'a, 'b>
          previous: Map<'c, 'b>
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
          previous = Map.empty
          normalizer = normalFun
          scorer = scoreFun }

    let isAddable aList item =
        let { normalizer = n; scorer = f; previous = p } = aList
        match Map.tryFind (n item) p with
        | None -> true
        | Some(i) -> (f item) < i

    let add aList item =
        let { itemMap = iMap; previous = p; normalizer = n; scorer = f } = aList
        if isAddable aList item then
            { aList with
                  itemMap = Map.add (f item) (item :: (findDefault [] iMap (f item))) iMap
                  previous = Map.add (n item) (f item) p }
        else
            aList

    // a more efficient version of List.map (add aList) items
    let addList aList items =
        let { itemMap = iMap; previous = p; normalizer = n; scorer = f } = aList
        { aList with
              itemMap =
                  items
                  |> List.filter (isAddable aList)
                  |> List.groupBy f
                  |> List.fold (fun aMap (v, al) -> Map.add v (List.append al (findDefault [] aMap v)) aMap) iMap
              previous = List.fold (fun s i -> Map.add (n i) (f i) s) p items }

    let pop aList =
        let { itemMap = iMap } = aList
        match minKey iMap with
        | None -> None
        | Some(mk) ->
            match Map.find mk iMap with
            | [] -> None
            | [ a ] -> Some(a, { aList with itemMap = Map.remove mk iMap })
            | a :: rest -> Some(a, { aList with itemMap = Map.add mk rest iMap })
 