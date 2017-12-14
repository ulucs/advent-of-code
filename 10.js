const inputs = [
  ...[...'flqrgnkx-0'].map(s => s.charCodeAt(0)),
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

const pad = (str, len, char = '0') => `${char.repeat(len - str.length)}${str}`;

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

module.exports = {
  calcKH(inps) {
    const inputs = [...[...inps].map(s => s.charCodeAt(0)), 17, 31, 73, 47, 23];

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

    return reformend;
  }
};
