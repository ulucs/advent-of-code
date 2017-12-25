const fs = require('fs');
const input = fs
  .readFileSync('20input.txt')
  .toString()
  .split('\n')
  .filter(a => a);

const particles = input
  .map(vs => vs.match(/<.*?>/g).map(v => v.match(/[0-9-]+/g).map(Number)))
  .map(([p, v, a], i) => ({p, v, a, i}));

function sumAbs(...v) {
  return v.map(Math.abs).reduce((a, b) => a + b);
}

function getClose({p: p1, v: v1, a: a1}, {p: p2, v: v2, a: a2}) {
  const aDiff = sumAbs(...a1) - sumAbs(...a2);
  if (aDiff !== 0) return aDiff;
  const vDiff = sumAbs(...v1) - sumAbs(...v2);
  if (vDiff !== 0) return vDiff;
  return sumAbs(...p1) - sumAbs(...p2);
}

const sol1 = particles.reduce((a1, a2) => (getClose(a1, a2) <= 0 ? a1 : a2));
console.log(sol1);

function sum3([a1, a2, a3], [b1, b2, b3]) {
  return [a1 + b1, a2 + b2, a3 + b3];
}

function calcPos({p, v, a}, t) {
  return [p, v.map(vi => vi * t), a.map(ai => ai * (t + 1) * t / 2)].reduce(
    sum3
  );
}

function doesCollide(i1, i2) {
  if (i1.i === i2.i) return false;
  let minDist = Number.MAX_VALUE;
  for (let t = 0; true; t++) {
    const [pos1, pos2] = [i1, i2].map(i => calcPos(i, t));
    if (pos1.toString() === pos2.toString()) return true;
    const dist = sumAbs(...[pos1, pos2].reduce(sum3));
    if (dist > minDist) return false;
    minDist = dist;
  }
}

const destroyed = new Set();
for (let t = 0; true; t++) {
  const newPos = particles
    .filter(({i}) => !destroyed.has(i))
    .map(p => ({pos: calcPos(p, t), i: p.i}));
  newPos
    .filter(({pos, i}) =>
      newPos.some(
        ({pos: pos2, i: i2}) => i2 !== i && pos.toString() === pos2.toString()
      )
    )
    .forEach(({pos, i}) => {
      destroyed.add(i);
      console.log(destroyed.size);
    });
}
