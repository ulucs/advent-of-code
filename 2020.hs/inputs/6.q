st:{$[count l:ss[y;x];(enlist first[l]#y),(count x) _/: l _ y;enlist y]}
as:st["\n"] each st["\n\n"]"c"$read1`6.txt
show sum {count distinct (,/) x} each as / silver
show sum {count distinct x where y = sum each flip (x =/:) x}'[(,/) each as; count each as] / gold

k)e:,::;st:{$[#:l:ss[y;x];(e l[0]#y),(#:x)_/:l_y;e y]}; as:st["\n"]'st["\n\n"]"c"$1::`6.txt
k)0N!+/{#:?:,/x}'as;+/{#:?:x[&:y=+/'+:x=/:x]}'[,/'as;#:'as]