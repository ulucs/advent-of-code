use std::{collections::HashSet, fs, str::FromStr};

#[derive(Hash, PartialEq, Eq, Clone, Copy, Debug)]
pub struct Page(i32);

#[derive(Debug)]
pub struct PageParseErr;
impl FromStr for Page {
    type Err = PageParseErr;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        s.parse::<i32>().map(|n| Self(n)).map_err(|_| PageParseErr)
    }
}

pub struct PageOrder(HashSet<(Page, Page)>);

#[derive(Debug)]
pub struct PageOrderParseErr;
impl FromStr for PageOrder {
    type Err = PageOrderParseErr;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let ords: HashSet<(Page, Page)> = s
            .lines()
            .map(|l| l.split_once("|").unwrap())
            .map(|(sm, bg)| (sm.parse().unwrap(), bg.parse().unwrap()))
            .collect();

        Ok(Self(ords))
    }
}

impl PageOrder {
    fn cmp(&self, p1: &Page, p2: &Page) -> std::cmp::Ordering {
        {
            self.0
                .get(&(*p2, *p1))
                .map(|_| std::cmp::Ordering::Greater)
                .or_else(|| self.0.get(&(*p1, *p2)).map(|_| std::cmp::Ordering::Less))
                .unwrap()
        }
    }
}

pub fn input(inp: Option<String>) -> (PageOrder, Vec<Vec<Page>>) {
    let input = inp
        .or(fs::read_to_string("inputs/5.txt").ok())
        .expect("Something went wrong reading the file");

    let (pm_str, lists_str) = input.split_once("\n\n").unwrap();

    (
        pm_str.parse().unwrap(),
        lists_str
            .lines()
            .map(|line| line.split(",").map(|n| n.parse().unwrap()).collect())
            .collect(),
    )
}

pub fn silver((ord, items): &(PageOrder, Vec<Vec<Page>>)) -> i32 {
    items
        .iter()
        .filter(|pages| pages.is_sorted_by(|p1, p2| Some(ord.cmp(p1, p2))))
        .map(|pgs| pgs.get((pgs.len() - 1) / 2).unwrap().0)
        .sum()
}

pub fn gold((ord, items): &(PageOrder, Vec<Vec<Page>>)) -> i32 {
    items
        .iter()
        .filter(|pages| !pages.is_sorted_by(|p1, p2| Some(ord.cmp(p1, p2))))
        .map(|pages| {
            let mut mp = pages.clone();
            mp.sort_by(|p1, p2| ord.cmp(p1, p2));
            mp
        })
        .map(|pgs| pgs.get((pgs.len() - 1) / 2).unwrap().0)
        .sum()
}

#[cfg(test)]
mod test {
    use crate::day::{input, silver};

    #[test]
    fn silver_example() {
        assert_eq!(
            143,
            silver(&input(Some(
                "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"
                    .to_owned()
            )))
        )
    }
}
