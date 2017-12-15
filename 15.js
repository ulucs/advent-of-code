function* numbers(start = 0, multiplier = 0, checker = 2) {
  let nd = checker - 1;
  let prev = start;
  while (true) {
    prev = (prev * multiplier) % 2147483647;
    if ((prev & nd) === 0) yield prev;
  }
}

const genA = numbers(699, 16807, 4);
const genB = numbers(124, 48271, 8);

let score = 0;
for (let i = 0; i < 5e6; i++) {
  const scr1 = genA.next().value;
  const scr2 = genB.next().value;
  if ((scr1 & 65535) === (scr2 & 65535)) score++;
}

console.log(score);
