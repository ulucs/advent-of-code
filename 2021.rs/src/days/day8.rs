use std::{
    collections::{HashMap, HashSet},
    hash::Hash,
    iter::repeat,
};

fn sort(chars: &str) -> Vec<char> {
    let mut chars: Vec<char> = chars.chars().collect();
    chars.sort();
    chars.iter().cloned().collect()
}

fn input() -> Vec<(Vec<Vec<char>>, Vec<Vec<char>>)> {
    std::fs::read_to_string("inputs/8.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|l| {
            let (codes, display) = l.split_once(" | ").expect("wrong split!");

            let codes: Vec<Vec<char>> = codes.split(" ").map(sort).collect();
            let display: Vec<Vec<char>> = display.split(" ").map(sort).collect();

            (codes, display)
        })
        .collect()
}

fn cross_product_set<T: Hash + Eq>(
    x: HashSet<T>,
    y: HashSet<T>,
) -> impl Iterator<Item = HashSet<&'static T>> {
    let xl = x.len();
    let yl = y.len();

    Box::new(
        x.iter()
            .flat_map(move |a| repeat(a).take(yl))
            .zip(y.iter().cycle())
            .map(|(a, b)| HashSet::<&T>::from_iter([a, b].iter().cloned())),
    )
}

macro_rules! cross_product {
    ($x: expr) => {
        $x.iter().map(|a| HashSet::from_iter(repeat(a).take(1)))
    };
    ($x: expr, $($y: expr), +) => {
        $x
    };
}

fn digit_maps() -> HashMap<i32, HashSet<i32>> {
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        .iter()
        .cloned()
        .map(|d| (d, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].iter().cloned().collect()))
        .collect()
}

fn digit_disps() -> HashMap<i32, HashSet<char>> {
    HashMap::from([
        (0, "ABCEFG".chars().collect()),
        (1, "CF".chars().collect()),
        (2, "ACDEG".chars().collect()),
        (3, "ACDFG".chars().collect()),
        (4, "BCDF".chars().collect()),
        (5, "ABDFG".chars().collect()),
        (6, "ABDEFG".chars().collect()),
        (7, "ACF".chars().collect()),
        (8, "ABCDEFG".chars().collect()),
        (9, "ABCDFG".chars().collect()),
    ])
}

fn disp_maps() -> HashMap<char, HashSet<char>> {
    "ABCDEFG"
        .chars()
        .map(|c| (c, "abcdefg".chars().collect()))
        .collect()
}

#[derive(Debug)]
struct DispSuper {
    disp_super: HashMap<char, HashSet<char>>,
    digit_disp: HashMap<i32, HashSet<char>>,
    digit_super: HashMap<i32, HashSet<i32>>,
    shuffled_disps: Vec<Vec<char>>,
}

impl DispSuper {
    fn new(shuffled_disps: Vec<Vec<char>>) -> Self {
        Self {
            disp_super: disp_maps(),
            digit_super: digit_maps(),
            digit_disp: digit_disps(),
            shuffled_disps,
        }
    }

    fn eliminate(mut self) {}
}

pub fn silver() -> usize {
    input()
        .iter()
        .map(|(_, disp)| {
            disp.iter()
                .filter(|c| match c.len() {
                    2 | 3 | 4 | 7 => true,
                    _ => false,
                })
                .count()
        })
        .sum()
}
pub fn gold() -> i32 {
    0
}
