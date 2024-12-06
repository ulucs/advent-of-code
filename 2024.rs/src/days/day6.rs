use std::{
    collections::{HashMap, HashSet},
    fs::read,
};

use util::Point;
mod util;

#[derive(Debug, Clone)]
pub struct Map(HashMap<Point, bool>);

impl Point {
    fn turn_right(&self) -> Self {
        match self {
            Point(-1, 0) => Point(0, 1),
            Point(0, 1) => Point(1, 0),
            Point(1, 0) => Point(0, -1),
            Point(0, -1) => Point(-1, 0),
            _ => panic!("ree"),
        }
    }
}

pub fn input(inp: Option<Vec<u8>>) -> (Map, Point, Point) {
    (
        Map(HashMap::from_iter(
            inp.clone()
                .or(read("inputs/6.txt").ok())
                .unwrap()
                .split(|c| c == &('\n' as u8))
                .enumerate()
                .flat_map(|(i, row)| {
                    row.iter()
                        .enumerate()
                        // # == blocked
                        .map(move |(j, c)| (Point(i as i32, j as i32), c == &('#' as u8)))
                }),
        )),
        inp.or(read("inputs/6.txt").ok())
            .unwrap()
            .split(|c| c == &('\n' as u8))
            .enumerate()
            .flat_map(|(i, row)| {
                row.iter()
                    .enumerate()
                    .filter(|(_, c)| c == &&('^' as u8))
                    .map(move |(j, _)| Point(i as i32, j as i32))
            })
            .next()
            .unwrap(),
        Point(-1, 0),
    )
}

// Some <=> doesn't loop
fn _silver((map, start, init_dir): &(Map, Point, Point)) -> Option<HashSet<Point>> {
    let mut dir = init_dir.clone();
    let mut loc = start.clone();
    let mut stepped: HashSet<(Point, Point)> = HashSet::from_iter([(loc, dir)]);

    while let Some(blocked) = map.0.get(&(loc + dir)) {
        if *blocked {
            dir = dir.turn_right()
        } else {
            loc = loc + dir;
            if stepped.contains(&(loc, dir)) {
                return None;
            }
            stepped.insert((loc, dir));
        };
    }

    Some(HashSet::from_iter(stepped.iter().map(|(pt, _)| *pt)))
}

pub fn silver(inp: &(Map, Point, Point)) -> usize {
    _silver(inp).unwrap().len()
}

pub fn gold((map, start, init_dir): &(Map, Point, Point)) -> usize {
    let mut possible_blocks = _silver(&(map.clone(), *start, *init_dir)).unwrap();
    possible_blocks.remove(start);

    possible_blocks
        .iter()
        .filter(|&&block| {
            let mut m = map.0.clone();
            m.insert(block, true);
            _silver(&(Map(m), *start, *init_dir)).is_none()
        })
        .count()
}

#[cfg(test)]
mod test {
    use crate::day::{gold, silver};

    use super::input;

    #[test]
    fn test_silver() {
        let inp = input(Some(
            "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
                .into(),
        ));
        assert_eq!(41, silver(&inp));
    }

    #[test]
    fn test_gold() {
        let inp = input(Some(
            "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
                .into(),
        ));
        assert_eq!(6, gold(&inp));
    }
}
