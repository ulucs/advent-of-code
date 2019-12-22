namespace AoC

open System.Text.RegularExpressions

module Day14 =
    let parseEl str =
        let el = Regex.Match(str, "[A-Z]+").Value

        let ct =
            Regex.Match(str, "[0-9]+").Value
            |> int
            |> bigint
        el, ct

    let first (x, _) = x
    let rTuple (x, y) = y, x
    let rev f x y = f y x

    let b2i b =
        if b then 1I else 0I

    let input =
        Utils.getInputLines 14
        |> Array.map (fun s -> s.Split("=>"))
        |> Array.map (Array.map (fun s -> s.Split(",")))
        |> Array.map (Array.map (Array.map parseEl))

    let recipes = Array.fold (fun rcp [| ins; [| pr, ct |] |] -> Map.add pr (ct, ins) rcp) Map.empty input

    let elems =
        Array.concat (Array.concat input)
        |> Array.map first
        |> Set.ofArray
        |> List.ofSeq

    let modify el diff map = Map.add el (diff + (Map.find el map)) map

    let makeEl deficit el bag =
        let (made, toSubs) = Map.find el recipes
        let times = (deficit / made) + b2i (deficit % made <> 0I)
        Array.fold (fun bg (mt, df) -> modify mt (-df * times) bg) (modify el (times * made) bag) toSubs

    let rec fulfill bag =
        if Map.forall (fun k v -> k = "ORE" || v >= 0I) bag then
            -(Map.find "ORE" bag)
        else
            let toMake = Map.findKey (fun k v -> k <> "ORE" && v < 0I) bag
            let deficit = Map.find toMake bag

            fulfill (makeEl -deficit toMake bag)

    let silver fuel =
        let bag = List.zip elems (List.replicate (List.length elems) 0I) |> Map.ofList
        fulfill (Map.add "FUEL" -fuel bag)

    let rec bsearch f top btm xst =
        let mid = (top + btm) / 2I
        let x = f mid

        if mid = btm then mid
        else if x = xst then mid
        else if x > xst then bsearch f mid btm xst
        else bsearch f top mid xst

    let gold xst = bsearch silver xst 1I xst

    printfn "%A" (silver 1I)
    printfn "%A" (gold 1000000000000I)
 