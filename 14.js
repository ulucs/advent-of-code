const {calcKH} = require('./10.js');

const pad = (str, len, char = '0') =>
  `${char.repeat(Math.max(len - str.length, 0))}${str}`;

const input = 'nbysizxe';
const rows = Array(128)
  .fill(input)
  .map((s, i) => `${s}-${i}`);

const getAdjs = (gen, i, j) =>
  [[1, 0], [-1, 0], [0, 1], [0, -1]].map(([d1, d2]) => [
    (gen[i + d1] || [])[j + d2] || 0,
    i + d1,
    j + d2
  ]);

const gen = rows.map(calcKH).map(hash =>
  hash
    .split('')
    .map(h => parseInt(h, 16).toString(2))
    .map(s => pad(s, 4).split(''))
    .reduce((a, b) => [...a, ...b])
    .map(n => -Number(n))
);

const logGen = () =>
  gen
    .map(row => row.map(i => (i === -1 ? '_' : i === 0 ? '.' : i)).join(''))
    .forEach(r => console.log(r));

const sol1 = gen.reduce((a, b) => [...a, ...b]).reduce((a, b) => a + b);

function markRecursively(gen, i, j, groupCount = 1) {
  gen[i][j] = groupCount;
  const neighbors = getAdjs(gen, i, j)
    .filter(([it]) => it === -1)
    .map(([, i2, j2]) => markRecursively(gen, i2, j2, groupCount));
  // logGen();
  return 0;
}

let groupCount = 0;
gen.forEach((row, i) =>
  row.forEach(
    (item, j) => item === -1 && markRecursively(gen, i, j, ++groupCount)
  )
);

console.log(groupCount);
