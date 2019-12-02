const input = `24/14
30/24
29/44
47/37
6/14
20/37
14/45
5/5
26/44
2/31
19/40
47/11
0/45
36/31
3/32
30/35
32/41
39/30
46/50
33/33
0/39
44/30
49/4
41/50
50/36
5/31
49/41
20/24
38/23
4/30
40/44
44/5
0/43
38/20
20/16
34/38
5/37
40/24
22/17
17/3
9/11
41/35
42/7
22/48
47/45
6/28
23/40
15/15
29/12
45/11
21/31
27/8
18/44
2/17
46/17
29/29
45/50`
  .replace(/[0-9]+/g, x => (x.length === 1 ? '0' + x : x))
  .split('\n');

const exclude = (a = [''], b = ['']) => {
  const r = new Set(a);
  b.forEach(i => r.delete(i));
  return Array.from(r);
};
const getOtherPin = (a = [], p = '') => (a[0] === p ? a[1] : a[0]);
const calcStr = bridgeParts =>
  bridgeParts
    .map(i => i.split('/').map(Number))
    .reduce((a, [b1, b2]) => a + b1 + b2, 0);

const parts = input;
const depth = input.filter(i => i.includes('00')).map(bp => ({
  bridgeParts: [bp],
  openPin: bp.split('/').find(i => i !== '00')
}));
let maxls = [0, 0];

while (depth.length) {
  const {bridgeParts, openPin} = depth.pop();
  const avIts = exclude(parts, bridgeParts).filter(part =>
    part.includes(openPin)
  );
  if (!avIts.length) {
    if (bridgeParts.length >= maxls[0]) {
      const str = calcStr(bridgeParts);
      maxls = [
        bridgeParts.length,
        bridgeParts.length > maxls[0] || str >= maxls[1] ? str : maxls[1]
      ];
    }
    continue;
  }
  for (const newPart of avIts) {
    depth.push({
      bridgeParts: [...bridgeParts, newPart],
      openPin: getOtherPin(newPart.split('/'), openPin)
    });
  }
}

console.log(maxls[1]);
