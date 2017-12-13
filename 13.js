const scannerList = `0: 3
1: 2
2: 5
4: 4
6: 4
8: 6
10: 6
12: 6
14: 8
16: 6
18: 8
20: 8
22: 8
24: 12
26: 8
28: 12
30: 8
32: 12
34: 12
36: 14
38: 10
40: 12
42: 14
44: 10
46: 14
48: 12
50: 14
52: 12
54: 9
56: 14
58: 12
60: 12
64: 14
66: 12
70: 14
76: 20
78: 17
80: 14
84: 14
86: 14
88: 18
90: 20
92: 14
98: 18`;

const testScr = `0: 3
1: 2
4: 4
6: 4`;

class Scanner {
  constructor(depth = 0) {
    this.depth = depth;
    this.period = (depth - 1) * 2;
    this.scanPoint = 0;
    this.traceback = false;
  }
  isAtZero(t = 0) {
    return Number.isInteger(t / this.period);
  }
  move() {
    this.scanPoint += this.traceback ? -1 : 1;
    if (this.scanPoint === this.depth - 1) this.traceback = true;
    if (this.scanPoint === 0) this.traceback = false;
    return this.scanPoint;
  }
}
const uniq = (arr = []) => Array.from(new Set(arr));
const getScanners = () =>
  scannerList
    .split('\n')
    .map(s => s.split(': ').map(Number))
    .reduce((scl, [p, d]) => {
      scl[p] = new Scanner(d);
      return scl;
    }, []);

function solution1(scanners) {
  let score = 0;
  for (let i = 0; i < scanners.length; i++) {
    const scr = scanners[i];
    const isCaught = scr && scr.scanPoint === 0;
    if (isCaught) score += i * scr.depth + 1;
    scanners.forEach(s => s.move());
  }
  return score;
}

function solution1fast(scanners) {
  return scanners
    .map((scr, i) => (scr.isAtZero(i) ? scr.depth * i : 0))
    .reduce((a, b) => a + b);
}

function s1fb(scanners = [], t = 0) {
  return scanners.some((scr, i) => scr.isAtZero(t + i));
}

function solution2() {
  const scanners = getScanners();
  let delay = 0;
  while (true) {
    const isUncaught = !s1fb(scanners, delay);
    if (isUncaught) return delay;
    delay++;
  }
}
