use std::fs;

pub fn input(maybe_input: Option<String>) -> Vec<(i64, Vec<i64>)> {
    maybe_input
        .or(fs::read_to_string("inputs/7.txt").ok())
        .expect("Something went wrong reading the file")
        .lines()
        .map(|line| line.split_once(": ").unwrap())
        .map(|(res, items)| {
            (
                res.parse().unwrap(),
                items.split(" ").map(|it| it.parse().unwrap()).collect(),
            )
        })
        .collect()
}

fn yield_results(items: &Vec<i64>) -> Vec<i64> {
    let mut it = items.iter();
    let first = it.next().unwrap();
    it.fold(vec![*first], |partials, next| {
        partials
            .iter()
            .flat_map(|&res| vec![res * next, res + next])
            .collect()
    })
}

fn yield_results_2(items: &Vec<i64>) -> Vec<i64> {
    let mut it = items.iter();
    let first = it.next().unwrap();
    it.fold(vec![*first], |partials, next| {
        partials
            .iter()
            .flat_map(|&res| {
                vec![
                    res * next,
                    res + next,
                    format!("{}{}", res, next).parse().unwrap(),
                ]
            })
            .collect()
    })
}

fn solve<Y>(inp: &Vec<(i64, Vec<i64>)>, yielder: Y) -> i64
where
    Y: Fn(&Vec<i64>) -> Vec<i64>,
{
    inp.iter()
        .filter_map(|(res, items)| yielder(items).iter().any(|mres| res == mres).then(|| res))
        .sum()
}

pub fn silver(inp: &Vec<(i64, Vec<i64>)>) -> i64 {
    solve(inp, yield_results)
}

pub fn gold(inp: &Vec<(i64, Vec<i64>)>) -> i64 {
    solve(inp, yield_results_2)
}

#[cfg(test)]
mod test {
    use crate::day::{gold, silver};

    use super::input;

    #[test]
    fn test_silver() {
        let input = input(Some(
            "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"
            .to_string(),
        ));

        assert_eq!(3749, silver(&input));
    }

    #[test]
    fn test_gold() {
        let input = input(Some(
            "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"
            .to_string(),
        ));

        assert_eq!(11387, gold(&input));
    }
}
