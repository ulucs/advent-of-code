use std::fs;

fn input() -> Vec<Vec<i32>> {
    fs::read_to_string("inputs/9.txt")
        .expect("Something went wrong reading the file")
        .lines()
        .map(|line| {
            line.chars()
                .map(|c| c.to_string().parse::<i32>().unwrap())
                .collect()
        })
        .collect()
}

fn zip_with<T, U, V, F>(a: Vec<T>, b: Vec<U>, f: F) -> Vec<V>
where
    F: Fn(T, U) -> V,
{
    a.into_iter()
        .zip(b.into_iter())
        .map(|(a, b)| f(a, b))
        .collect()
}

pub fn silver() -> usize {
    let mut map = input();
    let low_points_h = map
        .iter()
        .map(|l| {
            l.iter_mut()
                .scan(9, |p, n| {
                    let cmp = p < n;
                    *p = *n;
                    Some(cmp)
                })
                .collect()
        })
        .collect();

    0
}

pub fn gold() -> usize {
    0
}
