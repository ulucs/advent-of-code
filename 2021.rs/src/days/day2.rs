use std::fs;

enum Direction {
    Forward,
    Up,
    Down,
}
type Move = (Direction, i32);

fn input() -> Vec<Move> {
    fs::read_to_string("inputs/2.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|line| {
            let [dir, num] = <[&str; 2]>::try_from(line.split(" ").collect::<Vec<&str>>())
                .expect("Invalid input");
            let num = num.parse::<i32>().unwrap();

            let dir = match dir {
                "forward" => Direction::Forward,
                "up" => Direction::Up,
                "down" => Direction::Down,
                _ => panic!("Invalid direction"),
            };
            (dir, num)
        })
        .collect()
}

type Position = (i32, i32);

pub fn silver() -> i32 {
    let (x, y): Position = input().iter().fold((0, 0), |(x, y), (dir, ct)| match dir {
        Direction::Forward => (x + ct, y),
        Direction::Up => (x, y + ct),
        Direction::Down => (x, y - ct),
    });

    (x * y).abs()
}

type PosAim = (i32, i32, i32);

pub fn gold() -> i32 {
    let (x, y, _): PosAim = input()
        .iter()
        .fold((0, 0, 0), |(x, y, a), (dir, ct)| match dir {
            Direction::Forward => (x + ct, y + a * ct, a),
            Direction::Up => (x, y, a + ct),
            Direction::Down => (x, y, a - ct),
        });

    (x * y).abs()
}
