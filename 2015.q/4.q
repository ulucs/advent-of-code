st:"bgvyzdsv"
hs5:{((,/)string md5 x,string y)[til 5]}
{$[hs5[st;x]~"00000";x;x+1]}/[0]

hs6:{(md5 x,string y)[til 3]}
{$[hs6[st;x]~0x000000;x;x+1]}/[0]
