fn input() -> Vec<Vec<i32>> {
    std::fs::read_to_string("inputs/3.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|s| {
            s.chars()
                .map(|c| match c {
                    '0' => 0,
                    '1' => 1,
                    _ => panic!("Invalid input"),
                })
                .collect()
        })
        .collect()
}

fn transpose<T: Copy>(input: &Vec<Vec<T>>) -> Vec<Vec<T>> {
    let mut output = Vec::new();
    for i in 0..input[0].len() {
        let mut row = Vec::new();
        for j in 0..input.len() {
            row.push(input[j][i]);
        }
        output.push(row);
    }
    output
}

pub fn silver() -> i32 {
    let gamma = transpose(&input())
        .iter()
        // most common bit implementation: round to nearest int
        .map(|bs| (bs.iter().sum::<i32>() * 2) / (bs.len() as i32))
        .fold(0, |p, n| (p * 2 + n));

    gamma * (gamma ^ 0b111111111111)
}

fn eliminate_by_occurance(inp: &Vec<Vec<i32>>, most: bool, col: usize) -> Vec<i32> {
    let _mcb = transpose(&inp)[col].iter().sum::<i32>() * 2 / inp.len() as i32;
    let mcb = if most { _mcb } else { 1 - _mcb };

    let rem_inp: Vec<Vec<i32>> = inp
        .iter()
        .filter(|bs| bs[col] == mcb)
        .map(|bs| bs.clone())
        .collect();

    if rem_inp.len() == 1 {
        return rem_inp[0].clone();
    } else {
        return eliminate_by_occurance(&rem_inp, most, col + 1);
    }
}

pub fn gold() -> i32 {
    let inp = input();
    let oxy: i32 = eliminate_by_occurance(&inp, true, 0)
        .iter()
        .fold(0, |p, n| (p * 2 + n));
    let co2: i32 = eliminate_by_occurance(&inp, false, 0)
        .iter()
        .fold(0, |p, n| (p * 2 + n));

    return oxy * co2;
}
