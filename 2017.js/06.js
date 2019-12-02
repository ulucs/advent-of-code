let mems = '11	11	13	7	0	15	5	5	4	4	1	1	7	1	15	11'.split('\t').map(Number);

function redist(mem = [0], i = 0) {
  let trd = mem[i];
  mem[i] = 0;
  for (let j = i + 1; trd > 0; trd--, j++) {
    mem[j % mem.length]++;
  }
  return mem;
}

try {
  const sts = new Set([mems.join(' ')]);
  let loopItem = '';
  let g1 = 0;
  let g2 = 0;
  let isLooping = false;
  while (true) {
    const max = Math.max(...mems);
    const i = mems.indexOf(max);
    mems = redist(mems, i);
    g2++;
    const slm = mems.join(' ');
    if (!isLooping) {
      if (sts.has(slm)) {
        isLooping = true;
        g1 = g2;
        loopItem = slm;
      }
      sts.add(slm);
    } else if (loopItem === slm) {
      throw new Error(`Size of error: ${g2 - g1}.`);
    }
  }
} catch (e) {
  console.log(e);
}
