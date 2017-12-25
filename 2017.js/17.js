const input = 348;

class Circular extends Array {
  constructor(...args) {
    super(...args);
    this.currentPos = 0;
  }
  getNewPos() {
    return (this.currentPos + input) % this.length;
  }
  insert() {
    this.itemCount = this.itemCount + 1 || 1;
    this.currentPos++;
    return this.splice(this.currentPos, 0, this.itemCount);
  }
}

const circular = new Circular();
circular.push(0);

for (let i = 1; i <= 2017; i++) {
  circular.currentPos = circular.getNewPos();
  circular.insert();
}
console.log(circular[circular.indexOf(2017) + 1]);

const circular2 = {
  length: 1,
  currentPos: 0,
  getNewPos() {
    return (this.currentPos + input) % this.length;
  }
};
let lastInserted;
for (let i = 1; i <= 5e7; i++) {
  const newPos = circular2.getNewPos();
  if (newPos === 0) lastInserted = i;
  circular2.currentPos = newPos + 1;
  circular2.length++;
}
console.log(lastInserted);
