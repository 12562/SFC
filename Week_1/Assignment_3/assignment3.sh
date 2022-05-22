#!/bin/bash

#take the input of csv file name which is passed as an argument
a=$@

#cat $a >> assignment_3_file
#echo "---------------------------------------------------" >> assignment_3_file
#print the details of only 1st and 3rd column, if the first column data starts with letter "S"
#and sort it alphabetically based on first column data
#cat $a | grep '^"\?S' | awk -F ',' '{print $1","$3}' | sort -k 1 | sed 's/ *, */,/g'
cat $a | grep -i '^"\?S' | awk -F , '{print $3","$1}' | sort -k 2,2 -d -s -t ',' | awk -F , '{print $2","$1}'
