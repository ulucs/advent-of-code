st:{$[count l:ss[y;x];(enlist first[l]#y),(count x) _/: l _ y;enlist y]}; fe:first each; se:@[;1] each
del:ssr[;;""]; gb:{((2_) each b;("I"$) each first each b:st[", "] del[;"."] del[;" bag"] del[;" bags"] x)}
dt:(first each t)!gb each last each t:st[" bags contain "] each read0`7.txt; / parsing over

show count distinct 1_ (,/) {(,/) {where (count each fe dt)<>?[;x] each fe dt} each x}\[enlist "shiny gold"]; / silver
c:{$[(first first dt x) like " other";1;1+sum c'[first dt x]*(dt x) 1]}; show c["shiny gold"]; / gold