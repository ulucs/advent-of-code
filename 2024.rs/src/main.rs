use day::input;

#[path = "days/day2.rs"]
mod day;

fn main() {
    let input = &input(None);

    println!("silver: {:?}", day::silver(input));
    println!("gold: {:?}", day::gold(input));
}
