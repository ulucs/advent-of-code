const fs = require('fs');
const i = fs.readFileSync('19input.txt').toString();
const input = i.split('\n').filter(a => a);

let pos = [0, input[0].indexOf('|')];
const diagram = new Proxy(input, {
  get(t, p) {
    const [p1, ...rest] = p.split(',');
    return rest ? (t[p1] || [])[rest] : t[p1];
  }
});
let currentLetter = diagram[pos];
let currentDir = 'd';

const orthDirs = {
  u: ['l', 'r'],
  d: ['l', 'r'],
  l: ['u', 'd'],
  r: ['u', 'd']
};
const dm = {
  u: ([x, y]) => [x - 1, y],
  d: ([x, y]) => [x + 1, y],
  l: ([x, y]) => [x, y - 1],
  r: ([x, y]) => [x, y + 1]
};
const seenLetters = new Set();
let steps = 0;

do {
  if (currentLetter === '+') {
    [currentDir] = orthDirs[currentDir]
      .map(s => [s, dm[s]])
      .map(([s, f]) => [s, diagram[f(pos)]])
      .find(([a, b]) => b !== ' ');
  } else if (currentLetter !== '|' || currentLetter !== '-') {
    seenLetters.add(currentLetter);
  }
  pos = dm[currentDir](pos);
  currentLetter = diagram[pos];
  steps++;
} while (currentLetter && currentLetter !== ' ');

console.log(
  Array.from(seenLetters)
    .filter(l => l !== '|' && l !== '-')
    .join('')
);
console.log(steps);
