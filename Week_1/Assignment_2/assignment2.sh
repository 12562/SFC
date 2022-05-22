#!/bin/bash

#take the input of csv file name which is passed as an argument
a=$@

#print complete details only if the first column data is starting with letter "R"
#and sort it alphabetically based on first column data
cat $a | grep '^"\?R' | sort -k 1 -d

