#!/bin/bash

#take the input file name which is passed as an argument
input=$@
pwd >> `basename $input`
ls -lthra `pwd`/ >> `basename $input`
ls -lthra `pwd`/utilities/ >> `basename $input`
echo $input >> `basename $input`
cat $input >> `basename $input`

#find the valid IP addresses present in the input file
ip_addresses=`cat $input | grep -o "[^0-9.]\([0-9]\+\.\)\{3\}[0-9]\+[^0-9.]"`

#print the valid IP addresses found
for addr in $ip_addresses
do
   w=`echo $addr | sed 's/\./\n/g' | head -n 1 | tail -n 1`
   x=`echo $addr | sed 's/\./\n/g' | head -n 2 | tail -n 1`
   y=`echo $addr | sed 's/\./\n/g' | head -n 3 | tail -n 1`
   z=`echo $addr | sed 's/\./\n/g' | head -n 4 | tail -n 1`
   if [ $w -ge 0 ] && [ $w -le 255 ] && [ $x -ge 0 ] && [ $x -le 255 ] && [ $y -ge 0 ] && [ $y -le 255 ] && [ $z -ge 0 ] && [ $z -le 255 ]; then
      if [ $w -le 127 ]; then
         class="A";
      elif [ $w -le 191 ]; then
         class="B";
      elif [ $w -le 223 ]; then
         class="C";
      elif [ $w -le 239 ]; then
         class="D";
      elif [ $w -le 247 ]; then
         class="E";
      else
         class="Not Defined";
      fi
      echo "$addr $class";
   fi
done
