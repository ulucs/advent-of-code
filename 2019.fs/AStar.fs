namespace AoC

module AStar =
    type AStarCollection<'a, 'b when 'b: comparison> = Map<'b, 'a list>

    type AStarList<'a, 'b when 'b: comparison> =
        { itemMap: AStarCollection<'a, 'b>
          scorer: 'a -> 'b }

    let minKey map = Map.pick (fun k _ -> Some(k)) map

    let findDefault def map key =
        Map.tryFind key map
        |> function
        | None -> def
        | Some(vl) -> vl

    let newList scoreFun =
        { itemMap = Map.empty
          scorer = scoreFun }

    let add aList item =
        let { itemMap = iMap; scorer = f } = aList
        { itemMap = Map.add (f item) (item :: (findDefault [] iMap (f item))) iMap
          scorer = f }

    // a more efficient version of List.map (add aList) items
    let addList aList items =
        let { itemMap = iMap; scorer = f } = aList
        { itemMap =
              items
              |> List.groupBy f
              |> List.fold (fun aMap (v, al) -> Map.add v (List.append al (findDefault [] aMap v)) aMap) iMap
          scorer = f }

    let pop aList =
        let { itemMap = iMap; scorer = f } = aList
        let mk = minKey iMap
        let items = Map.find mk iMap
        match items with
        | [] -> None
        | [ a ] ->
            Some
                (a,
                 { itemMap = Map.remove mk iMap
                   scorer = f })
        | a :: rest ->
            Some
                (a,
                 { itemMap = Map.add mk rest iMap
                   scorer = f })
 