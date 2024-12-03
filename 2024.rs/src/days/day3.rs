use regex::{self, Regex};
use std::{fs, str::FromStr};

#[derive(Debug, PartialEq, Eq)]
pub struct ParseMulError;

#[derive(Debug)]
pub struct Mul(i32, i32);

impl FromStr for Mul {
    type Err = ParseMulError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        Some(s)
            .and_then(|s| s.strip_prefix("mul("))
            .and_then(|s| s.strip_suffix(")"))
            .and_then(|s| s.split_once(","))
            .and_then(|split| Some(Mul(split.0.parse().ok()?, split.1.parse().ok()?)))
            .ok_or(ParseMulError)
    }
}

pub fn input(_: Option<String>) -> String {
    fs::read_to_string("inputs/3.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .collect()
}

pub fn silver(input_str: &str) -> i32 {
    Regex::new(r"mul\(\d+,\d+\)")
        .unwrap()
        .find_iter(input_str)
        .map(|m| m.as_str())
        .flat_map(Mul::from_str)
        .map(|m| m.0 * m.1)
        .sum()
}

fn comment_out(input: &str) -> Vec<&str> {
    Regex::new(r"don't\(\).*?(do\(\)|$)")
        .unwrap()
        .split(input)
        .map(|s| s)
        .collect()
}

pub fn gold(input_str: &str) -> i32 {
    comment_out(input_str)
        .iter()
        .map(|str_piece| silver(&str_piece))
        .sum()
}

#[cfg(test)]
mod test {
    use crate::day::comment_out;

    #[test]
    fn input_comment() {
        let input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";
        assert_eq!(
            vec!["xmul(2,4)&mul[3,7]!^", "?mul(8,5))"],
            comment_out(input)
        );
    }
}
