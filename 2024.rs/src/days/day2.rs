use std::fs;

pub fn input(text_input: Option<String>) -> Vec<Vec<i32>> {
    text_input
        .or(fs::read_to_string("inputs/2.txt").ok())
        .expect("Something went wrong reading the file")
        .lines()
        .map(|line| {
            line.split_ascii_whitespace()
                .map(|n| n.parse().unwrap())
                .collect()
        })
        .collect()
}

pub fn silver(input: &Vec<Vec<i32>>) -> usize {
    input
        .iter()
        .filter(|nums| {
            let diffs: Vec<i32> = nums
                .iter()
                .zip(nums.iter().skip(1))
                .map(|(a, b)| a - b)
                .collect();

            diffs.iter().all(|d| d.abs() <= 3)
                && diffs
                    .iter()
                    .zip(diffs.iter().skip(1))
                    .all(|(d1, d2)| d1 * d2 > 0)
        })
        .count()
}

pub fn gold(input: &Vec<Vec<i32>>) -> usize {
    input
        .iter()
        .filter(|nums| {
            nums.iter().enumerate().any(|(i, _)| {
                let (_, nnums): (Vec<usize>, Vec<i32>) =
                    nums.iter().enumerate().filter(|(j, _)| i != *j).unzip();
                let diffs: Vec<i32> = nnums
                    .iter()
                    .zip(nnums.iter().skip(1))
                    .map(|(a, b)| a - b)
                    .collect();

                diffs.iter().all(|d| d.abs() <= 3)
                    && diffs
                        .iter()
                        .zip(diffs.iter().skip(1))
                        .all(|(d1, d2)| d1 * d2 > 0)
            })
        })
        .count()
}

#[cfg(test)]
mod tests {
    use crate::day::{gold, input, silver};

    #[test]
    fn silver_example() {
        assert_eq!(
            2,
            silver(&input(Some(
                "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"
                .into()
            )))
        )
    }

    #[test]
    fn gold_example() {
        assert_eq!(
            4,
            gold(&input(Some(
                "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"
                .into()
            )))
        )
    }
}
