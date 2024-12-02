use std::{collections::HashMap, fs, iter::zip};

pub fn input(_: Option<String>) -> (Vec<i32>, Vec<i32>) {
    fs::read_to_string("inputs/1.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|line| line.split_once("   ").unwrap())
        .map(|(a, b)| (a.parse::<i32>().unwrap(), b.parse::<i32>().unwrap()))
        .unzip()
}

pub fn silver(input: &(Vec<i32>, Vec<i32>)) -> i32 {
    let mut lists = input.clone();

    lists.0.sort();
    lists.1.sort();

    zip(lists.0, lists.1).map(|(a, b)| (a - b).abs()).sum()
}

fn count_items(mut cts: HashMap<i32, i32>, it: &i32) -> HashMap<i32, i32> {
    cts.insert(*it, cts.get(it).unwrap_or(&0) + 1);
    cts
}

pub fn gold((left, right): &(Vec<i32>, Vec<i32>)) -> i32 {
    let count_left = left.iter().fold(HashMap::new(), count_items);
    let count_right = right.iter().fold(HashMap::new(), count_items);

    count_left
        .iter()
        .map(|(k, c)| k * c * count_right.get(k).unwrap_or(&0))
        .sum()
}
