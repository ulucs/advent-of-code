const pattern = `.#./..#/###`;
const pl = [pattern];

const serialize = (s = [[]]) => s.map(k => k.join('')).join('/');
const decode = (s = '') => s.split('/').map(s => s.split(''));

const f = (arr = [[]]) =>
  arr.map((r, i, a) => a.map((c, j, b) => b[j][b.length - i - 1]));
const r = (arr = [[]]) => arr.map((r, i, a) => a[a.length - 1 - i]);

const inputs = `../.. => .#./###/##.
#./.. => ..#/.#./#.#
##/.. => ###/#../...
.#/#. => .#./..#/##.
##/#. => ..#/#.#/###
##/## => .##/.##/.#.
.../.../... => #.#./..##/##../###.
#../.../... => .###/.##./.##./....
.#./.../... => ####/..../..../.#.#
##./.../... => #.../#..#/#.../###.
#.#/.../... => ..##/###./..#./.#..
###/.../... => #.../#.#./..#./#.#.
.#./#../... => #.#./..#./.#../...#
##./#../... => ###./.###/#.##/.#..
..#/#../... => .##./.##./####/####
#.#/#../... => ..##/.#.#/##../#.##
.##/#../... => ...#/..##/...#/#...
###/#../... => ..../##.#/..#./###.
.../.#./... => ###./..##/#..#/#.#.
#../.#./... => #..#/..#./#.##/#..#
.#./.#./... => ##.#/..../...#/....
##./.#./... => #.#./.##./.###/####
#.#/.#./... => ####/.##./.#../##.#
###/.#./... => #.##/..../.#.#/.##.
.#./##./... => ##.#/#.##/#.##/..##
##./##./... => .###/..../#.../..#.
..#/##./... => ..../.#../..#./##..
#.#/##./... => #.##/##../..##/.#.#
.##/##./... => ..../..#./#..#/....
###/##./... => #..#/#.##/##.#/..##
.../#.#/... => ..../#.#./.##./.#.#
#../#.#/... => .###/.#.#/#.#./..#.
.#./#.#/... => ####/#.../.#../.##.
##./#.#/... => ..##/..#./.#.#/#.#.
#.#/#.#/... => #.##/##../##../#..#
###/#.#/... => .###/.##./.##./.#.#
.../###/... => ##.#/..##/...#/..##
#../###/... => ..##/####/..#./.###
.#./###/... => #.##/#.##/.##./..##
##./###/... => #.../.#.#/####/..##
#.#/###/... => #.../.###/..../.###
###/###/... => .##./####/##../..#.
..#/.../#.. => #..#/.###/.#.#/##.#
#.#/.../#.. => ###./.##./.##./##..
.##/.../#.. => .###/.#../...#/.#.#
###/.../#.. => ###./..##/..##/.#.#
.##/#../#.. => ##.#/...#/####/#.##
###/#../#.. => .#.#/...#/.###/#..#
..#/.#./#.. => #.#./.###/##../#...
#.#/.#./#.. => ####/..#./.###/##..
.##/.#./#.. => #.#./##../..../#.#.
###/.#./#.. => .#.#/#.#./#.../#.#.
.##/##./#.. => ##../.#../...#/..#.
###/##./#.. => ##../#.../.###/..#.
#../..#/#.. => ##../####/##.#/#.##
.#./..#/#.. => #..#/..../..#./#...
##./..#/#.. => ..#./..##/#.##/#.##
#.#/..#/#.. => #.##/..#./.#.#/.#..
.##/..#/#.. => ###./##../.#.#/##..
###/..#/#.. => #.#./.#.#/.#.#/#..#
#../#.#/#.. => #..#/.#.#/####/.#.#
.#./#.#/#.. => #.../#.##/#.../#.#.
##./#.#/#.. => .##./.#../.#.#/..#.
..#/#.#/#.. => ##.#/.###/#..#/#...
#.#/#.#/#.. => .#.#/.###/#..#/.#..
.##/#.#/#.. => ..#./####/.#../...#
###/#.#/#.. => .###/.#../.##./.#.#
#../.##/#.. => ..##/##.#/#.#./.###
.#./.##/#.. => ####/.##./..../.##.
##./.##/#.. => ...#/##../..##/..##
#.#/.##/#.. => .###/##.#/.###/..#.
.##/.##/#.. => ..#./##../..##/...#
###/.##/#.. => ###./.#.#/.###/.###
#../###/#.. => .##./##.#/##.#/..#.
.#./###/#.. => ...#/...#/##.#/#.##
##./###/#.. => .#../.#.#/.#.#/..#.
..#/###/#.. => ####/.#.#/..../##.#
#.#/###/#.. => ..../.###/.##./#.#.
.##/###/#.. => #.#./..##/.##./##..
###/###/#.. => .###/##.#/#.#./#.##
.#./#.#/.#. => ...#/###./..../####
##./#.#/.#. => ..../###./#.##/..##
#.#/#.#/.#. => #.../###./##.#/#...
###/#.#/.#. => #.../##../..#./..#.
.#./###/.#. => ###./..../.#.#/..#.
##./###/.#. => ##.#/..../.##./###.
#.#/###/.#. => #.##/##../...#/....
###/###/.#. => .##./####/##../.#..
#.#/..#/##. => .#.#/#.#./##.#/#.##
###/..#/##. => ####/##../..##/####
.##/#.#/##. => .#.#/#..#/####/##..
###/#.#/##. => #.##/.#../.###/.#..
#.#/.##/##. => ...#/.#.#/#.#./....
###/.##/##. => ..#./#.#./.###/###.
.##/###/##. => .###/.###/.##./.#..
###/###/##. => #.../#.../#.##/.#..
#.#/.../#.# => ..#./..../##../#.##
###/.../#.# => ..#./#.##/####/...#
###/#../#.# => #.../###./#.../...#
#.#/.#./#.# => ..##/#.##/.#.#/.#..
###/.#./#.# => #.../.#.#/#.#./##..
###/##./#.# => ##../.###/.#../...#
#.#/#.#/#.# => ..##/#.#./#.##/##..
###/#.#/#.# => .###/..##/..#./.###
#.#/###/#.# => ##.#/.###/..../.###
###/###/#.# => ##.#/#.##/##../..#.
###/#.#/### => ##../.#../#.#./##.#
###/###/### => .##./##../..#./.###`
  .split('\n')
  .map(s => s.split(' => '))
  .map(([k, v]) =>
    [
      a => a,
      a => f(a),
      a => f(f(a)),
      a => f(f(f(a))),
      a => r(a),
      a => r(f(a)),
      a => r(f(f(a))),
      a => r(f(f(f(a))))
    ]
      .map(fun => serialize(fun(decode(k))))
      .map(s => ({[s]: v}))
  )
  .reduce((a, b) => [...a, ...b])
  .reduce((a, b) => Object.assign({}, a, b));

const group2x2 = (arr = [[]]) => {
  const [row1, row2, ...rr] = arr;
  const [i11, i12, ...r1] = row1;
  const [i21, i22, ...r2] = row2;
  const two = [[i11, i12], [i21, i22]];
  if (!rr.length)
    return !r1.length
      ? [[two]]
      : [[two, ...group2x2([r1, r2]).reduce((a, b) => [...a, ...b])]];
  return [
    [two, ...group2x2([r1, r2]).reduce((a, b) => [...a, ...b])],
    ...group2x2(rr)
  ];
};

const group3x3 = (arr = [[]]) => {
  const [row1, row2, row3, ...rr] = arr;
  const [i11, i12, i13, ...r1] = row1;
  const [i21, i22, i23, ...r2] = row2;
  const [i31, i32, i33, ...r3] = row3;
  const three = [[i11, i12, i13], [i21, i22, i23], [i31, i32, i33]];
  if (!rr.length) {
    //last rows
    // if last items return the three
    if (!r1.length) return [[three]];
    // the last item is inside two arrays => flatten it twice
    return [[three, ...group3x3([r1, r2, r3]).reduce((a, b) => [...a, ...b])]];
  }
  return [
    [three, ...group3x3([r1, r2, r3]).reduce((a, b) => [...a, ...b])],
    ...group3x3(rr)
  ];
};

const joinGroups = (arr = [[[[]]]]) =>
  arr
    .map((lr, i) => arr[i].reduce((p, n) => p.map((r, j) => [...r, ...n[j]])))
    .reduce((a, b) => [...a, ...b]);

for (let i = 0; i < 18; i++) {
  const items = decode(pl[0]);
  const grouped = (items.length % 2 === 0 ? group2x2 : group3x3)(items);
  const enchanced = grouped.map(its =>
    its.map(it => decode(inputs[serialize(it)]))
  );
  pl.unshift(serialize(joinGroups(enchanced)));
}

console.log(pl[0].match(/#/g).length);