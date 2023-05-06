use std::fs;

fn input() -> (Vec<i32>, Vec<Vec<Vec<i32>>>) {
    let binding = fs::read_to_string("inputs/4.txt")
        .expect("Something went wrong reading the file")
        .split("\n\n")
        .map(|s| s.to_string())
        .collect::<Vec<String>>();
    let ([nums_s], cards_s) = binding.split_at(1) else {panic!()};

    let nums = nums_s
        .split(",")
        .map(|s| s.parse::<i32>().unwrap())
        .collect();
    let cards = cards_s
        .iter()
        .map(|s| {
            s.split("\n")
                .map(|l| {
                    l.trim()
                        .split_whitespace()
                        .map(|n| n.parse::<i32>().unwrap())
                        .collect()
                })
                .collect()
        })
        .collect::<Vec<Vec<Vec<i32>>>>();

    return (nums, cards);
}

fn transpose<T: Copy>(input: &Vec<Vec<T>>) -> Vec<Vec<T>> {
    let mut output = Vec::new();
    for i in 0..input[0].len() {
        let mut row = Vec::new();
        for j in 0..input.len() {
            row.push(input[j][i]);
        }
        output.push(row);
    }
    output
}

struct BingoCard {
    card: Vec<Vec<i32>>,
    checks: Vec<Vec<bool>>,
}

impl BingoCard {
    fn completed(&self) -> bool {
        self.checks.iter().any(|c| c.iter().all(|b| *b)) || {
            let transposed = transpose(&self.checks);
            transposed.iter().any(|c| c.iter().all(|b| *b))
        }
    }

    fn score(&self) -> i32 {
        self.card
            .iter()
            .flatten()
            .zip(self.checks.iter().flatten())
            .filter(|(_, c)| !**c)
            .map(|(n, _)| n)
            .sum()
    }

    fn check(&mut self, n: i32) {
        self.card.iter().enumerate().for_each(|(i, r)| {
            r.iter().enumerate().for_each(|(j, c)| {
                if *c == n {
                    self.checks[i][j] = true;
                }
            })
        });
    }
}

enum GameState {
    Won(i32),
    Playing(Vec<BingoCard>),
}

fn play_bingo(f: &dyn Fn(GameState, &i32) -> GameState) -> Option<i32> {
    let (nums, cards) = input();
    let cards_w_scores = cards
        .iter()
        .map(|c| BingoCard {
            card: c.clone(),
            checks: [false].repeat(25).chunks(5).map(|c| c.to_vec()).collect(),
        })
        .collect::<Vec<BingoCard>>();

    let GameState::Won(fs) = nums
      .iter()
      .fold(GameState::Playing(cards_w_scores), f)
      else { return None; };

    return Some(fs);
}

pub fn silver() -> i32 {
    play_bingo(&|gs, next| match gs {
        GameState::Won(s) => GameState::Won(s),
        GameState::Playing(mut cws) => {
            cws.iter_mut().for_each(|cw| cw.check(*next));

            let Some(cw) = cws.iter().find(|cw| cw.completed()) else {
                return GameState::Playing(cws)
            };

            GameState::Won(cw.score() * next)
        }
    })
    .unwrap_or(-1)
}

pub fn gold() -> i32 {
    play_bingo(&|gs, next| match gs {
        GameState::Won(s) => GameState::Won(s),
        GameState::Playing(mut cws) => {
            cws.iter_mut().for_each(|cw| cw.check(*next));

            if cws.len() == 1 {
                let cw = cws.first().unwrap();
                if cw.completed() {
                    GameState::Won(cw.score() * next)
                } else {
                    GameState::Playing(cws)
                }
            } else {
                cws.retain_mut(|cw| !cw.completed());
                GameState::Playing(cws)
            }
        }
    })
    .unwrap_or(-1)
}
