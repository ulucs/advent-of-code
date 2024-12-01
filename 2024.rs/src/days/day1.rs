use std::{collections::HashMap, fs, iter::zip};

fn input() -> (Vec<i32>, Vec<i32>) {
    fs::read_to_string("inputs/1.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|line| {
            line.split_ascii_whitespace()
                .map(|i| i.parse::<i32>().expect("Value too big for i32"))
                .collect()
        })
        .map(|nums: Vec<i32>| (*nums.first().unwrap(), *nums.last().unwrap()))
        .fold((vec![], vec![]), |(mut l1, mut l2), (n1, n2)| {
            l1.push(n1);
            l2.push(n2);
            (l1, l2)
        })
}

pub fn silver() -> i32 {
    let mut lists = input();

    lists.0.sort();
    lists.1.sort();

    zip(lists.0, lists.1).map(|(a, b)| (a - b).abs()).sum()
}

fn count_items(mut cts: HashMap<i32, i32>, it: &i32) -> HashMap<i32, i32> {
    cts.insert(*it, cts.get(it).unwrap_or(&0) + 1);
    cts
}

pub fn gold() -> i32 {
    let (left, right) = input();
    let count_left = left.iter().fold(HashMap::new(), count_items);
    let count_right = right.iter().fold(HashMap::new(), count_items);

    count_left
        .iter()
        .map(|(k, c)| k * c * count_right.get(k).unwrap_or(&0))
        .sum()
}
