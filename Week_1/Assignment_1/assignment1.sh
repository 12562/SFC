#!/bin/bash

#take the input of csv file name which is passed as an argument
a=$@

#sort the csv file alphabetically based on first column data
cat $a | sort -k 1 
