function* seq (l, h) {
  for (let i = l; i <= h; i++) { yield i; }
}

function iterate(f, n, x) {
    if (n === 0) { return []; }
    return [f(x), ...iterate(f, n-1, f(x))]
}

function shuffle(x, l) {
    const next = v => l[v];
    const findsv = (v, pck) => {
        const mxv = 9;
        let i = v == 1 ? mxv : v-1;
        while (pck.includes(i)) {
            i = i == 1 ? mxv : i-1;
        }
        return i;
    }

    const picked = iterate(next, 3, x);
    const sv = findsv(x, picked)
    const nx = next(picked[2]);

    l[x] = nx;
    l[picked[2]] = next(sv);
    l[sv] = picked[0];
    return nx;
}

// 523764819
const initL = [0, 9, 3, 7, 8, 2, 4, 6, 1, ...seq(10, 1000000), 5];

let shufval = 5;
for (let i = 0; i < 10000000; i++) {
  shufval = shuffle(shufval, initL);
}

const x = initL[1];
console.log(x * initL[x]);