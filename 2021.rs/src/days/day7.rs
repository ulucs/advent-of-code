fn input() -> Vec<i32> {
    std::fs::read_to_string("inputs/7.txt")
        .expect("Something went wrong reading the file")
        .trim()
        .split(",")
        .map(|c| c.parse::<i32>().unwrap())
        .collect()
}

pub fn silver() -> i32 {
    let mut its = input();
    its.sort();
    let med = its[its.len() / 2];

    its.iter().map(|x| (med - x).abs()).sum()
}

pub fn gold() -> i32 {
    let its = input();
    let mean = (its.iter().sum::<i32>() as f32 / its.len() as f32).floor() as i32;

    its.iter()
        .map(|x| (x - mean).abs() * ((x - mean).abs() + 1) / 2)
        .sum()
}
