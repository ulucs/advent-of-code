st:{$[count l:ss[y;x];(enlist first[l]#y),(count x) _/: l _ y;enlist y]}
ts:{`$"inputs/",x,".txt"}; r0:{read0 ts x}; r1:{"c"$ read1 ts x};