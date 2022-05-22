#!/bin/awk -f


BEGIN{
RS= ".";
FS=",";
OFS="\t"
}
{
print(NR)
}
