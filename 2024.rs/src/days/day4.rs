use std::{
    collections::BTreeMap,
    fs,
    ops::{self},
    str::FromStr,
};

pub fn input(over: Option<String>) -> CharMap {
    CharMap::from_str(&over.or(fs::read_to_string("inputs/4.txt").ok()).unwrap()).unwrap()
}

#[derive(PartialEq, Eq, PartialOrd, Ord, Clone, Copy, Debug)]
struct Point(i32, i32);

#[derive(Debug, Clone)]
pub struct CharMap(BTreeMap<Point, char>);

#[derive(Debug)]
pub struct ParseCharMapErr;
impl FromStr for CharMap {
    type Err = ParseCharMapErr;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        Ok(CharMap(BTreeMap::from_iter(
            s.lines().enumerate().flat_map(|(row, line)| {
                line.chars()
                    .enumerate()
                    .map(|(col, c)| (Point(row as i32, col as i32), c))
                    .collect::<Vec<_>>()
            }),
        )))
    }
}

impl ops::Mul<Point> for i32 {
    type Output = Point;
    fn mul(self, rhs: Point) -> Self::Output {
        Point(self * rhs.0, self * rhs.1)
    }
}

impl ops::Add<Point> for Point {
    type Output = Point;
    fn add(self, rhs: Point) -> Self::Output {
        Point(self.0 + rhs.0, self.1 + rhs.1)
    }
}

impl Point {
    fn all_directions() -> Vec<Self> {
        vec![
            Point(1, 0),
            Point(1, 1),
            Point(0, 1),
            Point(-1, 1),
            Point(-1, 0),
            Point(-1, -1),
            Point(0, -1),
            Point(1, -1),
        ]
    }

    fn crossmas_dirs() -> Vec<Self> {
        vec![Self(1, 1), Self(1, -1)]
    }
}

impl CharMap {
    fn xmas_from_point(&self, start: Point) -> Vec<String> {
        Point::all_directions()
            .iter()
            .filter_map(|&dir| {
                (0..4)
                    .map(|d| self.0.get(&(start + d * dir)))
                    .collect::<Option<String>>()
            })
            .collect()
    }

    fn is_mas_center(&self, start: Point) -> bool {
        Point::crossmas_dirs().iter().all(|&dir| {
            (-1..=1)
                .map(|d| self.0.get(&(start + d * dir)))
                .collect::<Option<String>>()
                .is_some_and(|s| s == "MAS" || s == "SAM")
        })
    }
}

pub fn silver(input: &CharMap) -> usize {
    input
        .0
        .keys()
        .flat_map(|&pt| input.xmas_from_point(pt))
        .filter(|w| w == "XMAS")
        .count()
}

pub fn gold(input: &CharMap) -> usize {
    input
        .0
        .keys()
        .filter(|&&pt| input.is_mas_center(pt))
        .count()
}

#[cfg(test)]
mod test {
    use super::{gold, input, silver};

    #[test]
    fn silver_example_passes() {
        assert_eq!(
            18,
            silver(&input(Some(
                "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"
                .to_owned()
            )))
        )
    }

    #[test]
    fn gold_example_passes() {
        assert_eq!(
            9,
            gold(&input(Some(
                "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"
                .to_owned()
            )))
        )
    }
}
