ls:read0`$"inputs/6.txt"; se:{ssr[;y;","] each x}; t:1000 1000#0; tl: {x+til 1+y-x}
d:flip ("*iiii";",")0:se[;" "] se[;" through "] ssr[;"turn ";""] each ls
fs:("on";"off";"toggle")!(1+0*;0*;1-); fsg:("on";"off";"toggle")!(1+;{(x-1)*0<x-1};2+);

show (sum/) {@[x;tl[y 2;y 4];@[;tl[y 1;y 3];fs y 0]]}/[(enlist t),d]
show (sum/) {@[x;tl[y 2;y 4];@[;tl[y 1;y 3];fsg y 0]]}/[(enlist t),d]