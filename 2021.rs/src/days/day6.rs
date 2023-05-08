use std::collections::HashMap;

#[derive(Debug)]
struct FishMap(HashMap<i32, i64>);

impl FishMap {
    fn entry(&mut self, key: i32) -> &mut i64 {
        self.0.entry(key).or_insert(0)
    }

    fn advance_day(&self) -> FishMap {
        let mut next = FishMap(HashMap::new());

        self.0.iter().for_each(|(k, v)| {
            if *k == 0 {
                *next.entry(6) += *v;
                *next.entry(8) += *v;
            } else {
                *next.entry(*k - 1) += *v;
            }
        });

        next
    }

    fn advance_days(self, n: i32) -> FishMap {
        (1..=n).fold(self, |acc, _| acc.advance_day())
    }
}

fn input() -> FishMap {
    std::fs::read_to_string("inputs/6.txt")
        .expect("Something went wrong reading the file")
        .trim()
        .split(",")
        .map(|c| c.parse::<i32>().unwrap())
        .fold(FishMap(HashMap::new()), |mut h, n| {
            *h.entry(n) += 1;
            h
        })
}

pub fn silver() -> i64 {
    input().advance_days(80).0.values().sum()
}

pub fn gold() -> i64 {
    input().advance_days(256).0.values().sum()
}
