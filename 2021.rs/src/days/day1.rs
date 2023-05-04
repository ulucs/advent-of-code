use std::fs;

fn input() -> Vec<i32> {
    fs::read_to_string("inputs/1.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|line| line.parse::<i32>().unwrap())
        .collect()
}

pub fn silver() -> usize {
    let inp = input();
    inp.iter()
        .zip(inp.iter().skip(1))
        .filter(|(a, b)| a < b)
        .count()
}

pub fn gold() -> usize {
    let inp = input();
    let win_sums: Vec<i32> = inp
        .iter()
        .zip(inp.iter().skip(1))
        .zip(inp.iter().skip(2))
        .map(|((a, b), c)| a + b + c)
        .collect();

    win_sums
        .iter()
        .zip(win_sums.iter().skip(1))
        .filter(|(a, b)| a < b)
        .count()
}
