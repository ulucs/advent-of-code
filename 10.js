const inputs = [
  ...[...'83,0,193,1,254,237,187,40,88,27,2,255,149,29,42,100'].map(s =>
    s.charCodeAt(0)
  ),
  17,
  31,
  73,
  47,
  23
];

const list = new Proxy(
  Array(256)
    .fill(0)
    .map((_, i) => i),
  {
    get(t, p) {
      return Number(p) ? t[Number(p) % t.length] : t[p];
    },
    set(t, p, v) {
      return Number(p) ? (t[Number(p) % t.length] = v) : (t[p] = v);
    }
  }
);

let skipSize = 0;
let index = 0;
const rounds = 64;

const groupEls = (arr = []) =>
  Array(arr.length / 16)
    .fill(0)
    .map((_, i) => arr.slice(i * 16, (i + 1) * 16));

for (let r = 0; r < rounds; r++) {
  for (const len of inputs) {
    const nums = Array(len)
      .fill(0)
      .map((_, i) => list[index + i])
      .reverse();

    for (let j = 0; j < nums.length; j++) {
      list[index + j] = nums[j];
    }
    index += len + skipSize;
    skipSize++;
  }
}

const reformend = groupEls(list)
  .map(its => its.reduce((a, b) => a ^ b))
  .map(n => n.toString(16))
  .map(s => (s.length < 2 ? '0' + s : s))
  .join('');

console.log(reformend);
