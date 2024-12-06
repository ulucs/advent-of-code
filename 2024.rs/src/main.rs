#![feature(is_sorted)]
use day::input;

#[path = "days/day6.rs"]
mod day;

fn main() {
    let input = &input(None);

    println!("silver: {:?}", day::silver(input));
    println!("gold  : {:?}", day::gold(input));
}
