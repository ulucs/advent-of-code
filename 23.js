const {execSync} = require('child_process');
const input = `set b 99
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23`;

const regProx = {
  get(t, p) {
    if (!isNaN(p)) return Number(p);
    return t[p] || 0;
  },
  set(t, p, v) {
    return (t[p] = Number(v));
  }
};

function* messageParser(input = '', messagesIn = [], messagesOut = []) {
  const inputs = input.split('\n');
  let lineNum = 0;
  let mulct = 0;
  const registers = new Proxy({}, regProx);

  while (lineNum < inputs.length) {
    const line = inputs[lineNum];
    const [com, a, b] = line.split(' ');
    switch (com) {
      case 'snd':
        messagesOut.push(registers[a]);
        break;
      case 'set':
        registers[a] = registers[b];
        break;
      case 'add':
        registers[a] += registers[b];
        break;
      case 'sub':
        registers[a] -= registers[b];
        break;
      case 'mod':
        registers[a] = registers[a] % registers[b];
        break;
      case 'mul':
        mulct++;
        registers[a] *= registers[b];
        break;
      case 'jnz':
        if (registers[a] !== 0) lineNum += registers[b] - 1;
        break;
    }
    lineNum++;
  }
  return mulct;
}

const parser = messageParser(input);
console.log(parser.next().value);

console.log(
  execSync("octave-cli --eval 'sum(1-isprime([109900:17:126901]))'")
    .toString()
    .match(/[0-9]+/)[0]
);
