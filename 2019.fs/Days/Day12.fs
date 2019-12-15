namespace AoC

module Day12 =
    let tryint (a: string) =
        try
            Some(int a)
        with _ -> None

    let trydiv a b =
        if (0 = (a % b)) then a / b
        else a

    type Planet =
        { location: int list
          velocity: int list }

    let addTuples = List.map2 (+)
    let tSum = List.reduce (+)
    let absTuples = List.map abs
    let subTuples = List.map2 (-)

    let b2i b =
        if b then 1
        else 0

    let potential planet = (tSum (absTuples planet.location)) * (tSum (absTuples planet.velocity))

    type direction =
        | X of int * int
        | Y of int * int
        | Z of int * int

    let coordinal =
        Array.map (fun p ->
            let { location = [ x; y; z ]; velocity = [ dx; dy; dz ] } = p
            (X(x, dx), Y(y, dy), Z(z, dz)))
        >> List.ofArray
        >> List.unzip3

    let planets =
        (Utils.getInput 12).Replace(",", "=").Replace(">", "=").Split("=")
        |> Array.filter (tryint >> (<>) None)
        |> Array.map int
        |> Array.chunkBySize 3
        |> Array.map (fun [| x; y; z |] ->
            { location = [ x; y; z ]
              velocity = [ 0; 0; 0 ] })

    let updateVelocity planets planet =
        Array.fold (fun dv oPlanet -> addTuples dv (List.map sign (subTuples oPlanet.location planet.location)))
            planet.velocity planets

    let moveTime planets =
        Array.map (fun p ->
            { location = p.location
              velocity = updateVelocity planets p }) planets
        |> Array.map (fun p ->
            { location = addTuples p.location p.velocity
              velocity = p.velocity })

    let rec stairway (planets: Planet []) past t =
        let (cx, cy, cz) = coordinal planets
        let cl = [ cx; cy; cz ]
        let bumps = List.map (fun c -> 1 - (b2i (Set.contains c past))) cl
        match bumps with
        | [ 0; 0; 0 ] -> t
        | dt -> stairway (moveTime planets) (List.fold (fun p c -> Set.add c p) past cl) (addTuples dt t)

    let silver planets =
        let mutable ps = planets
        for i in [ 1 .. 1000 ] do
            ps <- moveTime ps
        ps
        |> Array.map potential
        |> Array.reduce (+)

    let gold planets = stairway planets Set.empty [ 0; 0; 0 ]

    printfn "%d" (silver planets)
    printfn "%A" (gold planets)
