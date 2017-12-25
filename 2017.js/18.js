const input = `set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 316
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19`;

const regProx = {
  get(t, p) {
    if (!isNaN(p)) return Number(p);
    return t[p] || 0;
  },
  set(t, p, v) {
    return (t[p] = Number(v));
  }
};

function* messageParser(input = '', p = 0, messagesIn = [], messagesOut = []) {
  const inputs = input.split('\n');
  let lineNum = 0;
  const registers = new Proxy({p}, regProx);

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
      case 'mod':
        registers[a] = registers[a] % registers[b];
        break;
      case 'mul':
        registers[a] *= registers[b];
        break;
      case 'rcv':
        while (messagesIn.length === 0) yield;
        registers[a] = messagesIn.shift();
        break;
      case 'jgz':
        if (registers[a] > 0) lineNum += registers[b] - 1;
        break;
    }
    lineNum++;
  }
}

const arr1 = [];
const arr2 = [];
const program1 = messageParser(input, 0, arr1, arr2);
const program2 = messageParser(input, 1, arr2, arr1);
let prog1sent = 0;

do {
  program1.next();
  program2.next();
  prog1sent += arr1.length;
} while ([...arr1, ...arr2].length > 0);

console.log(prog1sent);
