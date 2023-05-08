use std::collections::HashMap;

#[derive(Hash, PartialEq, Eq, Debug)]
pub struct Point {
    x: i32,
    y: i32,
}

#[derive(Debug)]
struct Line {
    start: Point,
    end: Point,
}

fn range(start: i32, end: i32) -> Box<dyn Iterator<Item = i32>> {
    if start < end {
        Box::new(start..=end)
    } else {
        Box::new((end..=start).rev())
    }
}

impl Line {
    fn is_straight(&self) -> bool {
        (self.start.x == self.end.x) || (self.start.y == self.end.y)
    }

    fn points(&self) -> Vec<Point> {
        if self.is_straight() {
            if self.start.x == self.end.x {
                range(self.start.y, self.end.y)
                    .map(|y| Point { x: self.start.x, y })
                    .collect()
            } else {
                range(self.start.x, self.end.x)
                    .map(|x| Point { x, y: self.start.y })
                    .collect()
            }
        } else {
            range(self.start.x, self.end.x)
                .zip(range(self.start.y, self.end.y))
                .map(|(x, y)| Point { x, y })
                .collect()
        }
    }
}

fn input() -> Vec<Line> {
    std::fs::read_to_string("inputs/5.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|s| {
            let nums: Vec<i32> = s
                .split(" -> ")
                .flat_map(|p| {
                    p.split(",")
                        .map(|d| d.parse::<i32>().expect("error reading digits"))
                        .collect::<Vec<i32>>()
                })
                .collect();

            let [x1, y1, x2, y2] = <[i32; 4]>::try_from(nums).expect("Invalid input");
            Line {
                start: Point { x: x1, y: y1 },
                end: Point { x: x2, y: y2 },
            }
        })
        .collect()
}

pub fn silver() -> usize {
    let binding = input();
    let pts = binding
        .iter()
        .filter(|l| l.is_straight())
        .flat_map(|l| l.points())
        .fold(HashMap::new(), |mut h, p| {
            *h.entry(p).or_insert(0) += 1;
            h
        })
        .values()
        .filter(|&v| *v > 1)
        .count();

    return pts;
}

pub fn gold() -> usize {
    let binding = input();
    let pts = binding
        .iter()
        .flat_map(|l| l.points())
        .fold(HashMap::new(), |mut h, p| {
            *h.entry(p).or_insert(0) += 1;
            h
        })
        .values()
        .filter(|&v| *v > 1)
        .count();

    return pts;
}
