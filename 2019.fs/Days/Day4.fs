namespace AoC


module Day4 =
    let check (pass: int) =
        let digits =
            pass.ToString()
            |> Seq.toArray
            |> Array.map int

        let (inc, j) = digits |> Array.fold (fun (bl, a) b -> (bl && (b >= a), b)) (true, 0)
        let (dubs, j) = digits |> Array.fold (fun (bl, a) b -> (bl || (b = a), b)) (false, 0)

        let (dbl, i, j, k) =
            digits
            |> Array.append
            <| [| 10 |]
            |> Array.fold (fun (bl, a, b, c) d -> (bl || ((b = c) && (a <> b) && (c <> d)), b, c, d)) (false, 0, 0, 0)

        inc && dbl, inc && dubs

    let silver =
        let range = [ 137683 .. 596253 ]

        range |> List.countBy check

    printf "%A\n" silver
