const input = 265149;

const getSq = i => Math.ceil(Math.sqrt(i) / 2 + 0.5);

const getPath = i =>
  Array(getSq(i) * 2)
    .fill(0)
    .map((a, i) =>
      (i % 2 ? 'RU' : 'LD')
        .split('')
        .map(s => s.repeat(i + 1))
        .join('')
    )
    .join('')
    .substr(0, i - 1);

const getPos = i =>
  ['U', 'L', 'D', 'R']
    .map(d => ({[d]: (getPath(i).match(new RegExp(d, 'g')) || []).length}))
    .reduce((a, b) => Object.assign({}, a, b));

const getDist = i => {
  let cts = getPos(i);
  return Math.abs(cts.U - cts.D) + Math.abs(cts.L - cts.R);
};

const solution1 = getDist(input);

const getGpos = i => {
  let cts = getPos(i);
  return [cts.U - cts.D, cts.L - cts.R];
};

const makeGrid = l => {
  let sq = getSq(l) * 2 - 1;
  let mid = Math.floor(sq / 2);
  let gr = Array(sq)
    .fill(0)
    .map(s => Array(sq).fill(0));
  for (let i = 1; i <= l; i++) {
    let [p1, p2] = getGpos(i);
    gr[p1 + mid][p2 + mid] = i;
  }
  return gr;
};

const getSum = (a, [p1, p2], mid) =>
  [-1, 0, 1]
    .map((d1, i, o) =>
      o.map(d2 => (a[p1 + mid + d1] || [])[p2 + mid + d2] || 0)
    )
    .reduce((a, b) => [...a, ...b])
    .reduce((a, b) => a + b);

const makeNuGrid = l => {
  let sq = getSq(l) * 2 - 1;
  let mid = Math.floor(sq / 2);
  let gr = Array(sq)
    .fill(0)
    .map(s => Array(sq).fill(0));
  for (let i = 1; i <= l; i++) {
    let [p1, p2] = getGpos(i);
    gr[p1 + mid][p2 + mid] = getSum(gr, [p1, p2], mid) || 1;
  }
  return gr;
};

const getBig = j => {
  for (let i = 1; ; i++) {
    let rem = makeNuGrid((2 * i - 1) * (2 * i - 1))
      .reduce((p, n) => [...p, ...n])
      .filter(s => s > j);
    if (rem.length) return rem.sort((a, b) => a - b)[0];
  }
};

const solution2 = getBig(input);

console.dir(solution1, solution2);
