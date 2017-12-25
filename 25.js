function tm() {
  let state = 'A';
  let ind = 0;
  const tape = {};
  const tstates = new Set();

  for (let i = 0; i < 12794428; i++) {
    switch (state) {
      case 'A':
        if (!tape[ind]) {
          tape[ind] = 1;
          ind++;
          state = 'B';
          break;
        }
        tape[ind] = 0;
        ind--;
        state = 'F';
        break;
      case 'B':
        if (!tape[ind]) {
          tape[ind] = 0;
          ind++;
          state = 'C';
          break;
        }
        tape[ind] = 0;
        ind++;
        state = 'D';
        break;
      case 'C':
        if (!tape[ind]) {
          tape[ind] = 1;
          ind--;
          state = 'D';
          break;
        }
        tape[ind] = 1;
        ind++;
        state = 'E';
        break;
      case 'D':
        if (!tape[ind]) {
          tape[ind] = 0;
          ind--;
          state = 'E';
          break;
        }
        tape[ind] = 0;
        ind--;
        state = 'D';
        break;
      case 'E':
        if (!tape[ind]) {
          tape[ind] = 0;
          ind++;
          state = 'A';
          break;
        }
        tape[ind] = 1;
        ind++;
        state = 'C';
        break;
      case 'F':
        if (!tape[ind]) {
          tape[ind] = 1;
          ind--;
          state = 'A';
          break;
        }
        tape[ind] = 1;
        ind++;
        state = 'A';
        break;
    }
  }
  return Object.values(tape)
    .map(Number)
    .reduce((a, b) => a + b);
}

console.log(tm());
