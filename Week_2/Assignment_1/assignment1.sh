#!/bin/bash

#take the input file name which is passed as an argument
input="$@"

#cat $input >> week_2_assignment_1
#find the number of lines with one or more digits present in the input file
count=`cat $input | grep "\(^\| \|[[:punct:]]\)[0-9]\+\($\| \|[[:punct:]]\)" | wc -l`
#print the number of line with one or more digits found
echo "Number of lines having one or more digits are: $count"
#find the digits present in the input file

#print the digits found
echo "Digits found:"
cat $input | grep -o "\(^\| \|[[:punct:]]\)[0-9]\+\($\| \|[[:punct:]]\)" | tr -d "[:punct:]" | sed 's/ *//g'
