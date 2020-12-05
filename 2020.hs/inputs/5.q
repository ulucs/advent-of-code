t:read0`5bb.txt; b:"BFLR"!1 0 0 1
\t show max ns:asc sum each *[reverse 2 xexp til count first t] each b t;
\t show (ns where 2f = deltas ns)-1;