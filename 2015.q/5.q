ls:read0`$"inputs/5.txt"; se:{ssr[;y;","] each x}; t:1000 1000#0; tl: {x+til 1+y-x}
d:flip ("*iiii";",")0:se[;" "] se[;" through "] ssr[;"turn ";""] each ls
fs:("on";"off";"toggle")!(1+0*;0*;1-);
show (sum/) {@[x;tl[y 2;y 4];@[;tl[y 1;y 3];fs]]}/