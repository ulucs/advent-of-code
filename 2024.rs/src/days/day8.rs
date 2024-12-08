use std::{
    collections::{HashMap, HashSet},
    fs::read_to_string,
};

use itertools::Itertools;
use num_integer::gcd;
use util::Point;

mod util;

#[derive(Debug)]
pub struct AntennaMap {
    size: Point,
    antennas: HashMap<char, Vec<Point>>,
}

impl Point {
    fn dir(&self) -> Point {
        let r = match self {
            &Point(0, _) => self.to_owned(),
            &Point(x, y) => x.signum() * *self / gcd(x, y),
        };
        // println!("dir of {:?} = {:?}", self, r);
        r
    }
}

pub fn input(inp: Option<String>) -> AntennaMap {
    let _inp_map = inp.clone().or(read_to_string("inputs/8.txt").ok()).unwrap();
    let inp_map: Vec<_> = _inp_map.lines().collect();

    AntennaMap {
        size: Point(inp_map.len() as i32, inp_map.first().unwrap().len() as i32),
        antennas: inp_map
            .iter()
            .enumerate()
            .flat_map(|(i, line)| {
                line.chars()
                    .enumerate()
                    .filter(|(_, c)| *c != '.')
                    .map(move |(j, c)| (c, Point(i as i32, j as i32)))
            })
            .into_group_map(),
    }
}

pub fn silver(amap: &AntennaMap) -> usize {
    let yrange = 0..amap.size.0;
    let xrange = 0..amap.size.1;

    amap.antennas
        .iter()
        .flat_map(|(_, points)| {
            points
                .iter()
                .cartesian_product(points.iter())
                .filter(|(p1, p2)| p1 != p2)
                .map(|(p1, p2)| 2 * *p1 - *p2)
                .filter(|target_pt| yrange.contains(&target_pt.0) && xrange.contains(&target_pt.1))
        })
        .collect::<HashSet<_>>()
        .len()
}

pub fn gold(amap: &AntennaMap) -> usize {
    (0..amap.size.0)
        .cartesian_product(0..amap.size.1)
        .map(|(t1, t2)| Point(t1, t2))
        .filter(|&pt| {
            amap.antennas.iter().any(|(_, points)| {
                points.contains(&pt)
                    || points
                        .iter()
                        .map(|&a| (pt - a).dir())
                        .into_group_map_by(|&x| x)
                        .values()
                        .any(|v| v.len() > 1)
            })
        })
        .count()
}

#[cfg(test)]
mod test {
    use crate::day::{gold, input, silver};

    #[test]
    fn test_silver() {
        let test_inp = input(Some(
            "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"
            .to_string(),
        ));

        assert_eq!(14, silver(&test_inp));
    }

    #[test]
    fn test_gold() {
        let test_inp = input(Some(
            "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"
            .to_string(),
        ));

        assert_eq!(34, gold(&test_inp));
    }
}
