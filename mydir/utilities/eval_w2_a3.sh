#!/bin/bash

#set exit-on-error mode
set -e
#trap the exit signal instead of error(ERR) and handle it
#$? contains exit status of the last command executed
trap 'catch $? $LINENO' EXIT

#function to catch the exit signal and handle the exception
function catch() {
  #echo "catching EXIT!"
  if [ "$1" != "0" ]; then
    #error handling goes here
    #echo "Error $1 occurred on $2"
    #total_score=0
    echo "Marks scored: $total_score"
    remarks="EXCEPTION! Your code ran into an error! Debug your code."
    echo "Remarks: $remarks"
    #check whether temporary generated out.txt file exists or not
    [ -f out.txt ]
    if [ "$?" = 0 ]; then
      #delete the temporary generated out.txt file
      #echo "Return Code: $?, File out.txt exists!"
      rm -f out.txt
    else
      echo "Something went wrong, run this file again!"
      exit 1
    fi
  fi
}

#maximum score of the assignment
max_score=10
#to compute total marks scored after evaluation
total_score=0
#remarks to give as per the marks scored
remarks=""

#function to evaluate the student submitted file
function evaluate() {
  #run the student submitted file ($2) against the test_file ($3)
  #and generate temporary out.txt file
  awk -f "$2" "$3" > out.txt
  if [ "$?" = 0 ]; then
    #compare the out.txt file against the ideal_output_file
    #if the contents match, increment the total_score by test_case_weightage
    if cmp -s out.txt "$ideal_output_file"; then
      total_score=$(echo "scale=2;$total_score+$test_case_weightage" | bc -l)
      echo "Score up till Test case number $(($1 + 1)) = $total_score"
    else
      echo "Score up till Test case number $(($1 + 1)) = $total_score"
    fi
    #delete the temporary generated out.txt file
    rm -f out.txt
  fi
}

#take the student submitted file name from input arguments
submission_file=$1

#find Test TXT Files and their count
cmd_find_test_files=$(ls utilities/a3_test_case**.txt)
test_files_list=($cmd_find_test_files)
#print file names of all test txt files
#echo "Test TXT file list names: ${test_files_list[@]}"
#print number of all test txt files
no_of_test_cases="${#test_files_list[@]}"
echo "Number of Test TXT files: $no_of_test_cases"

#compute the weightage of each test case
test_case_weightage=$(echo "scale=2;$max_score/$no_of_test_cases" | bc -l)
#echo $test_case_weightage

#find Ideal Output TXT Files and their count
cmd_find_ideal_output_files=$(ls utilities/ideal_a3_test_case**.txt)
ideal_output_files_list=($cmd_find_ideal_output_files)
#print file names of all ideal output txt files
#echo "Ideal Output TXT file list names: ${ideal_output_files_list[@]}"
#print number of all ideal output txt files
no_of_ideal_output_files="${#ideal_output_files_list[@]}"
#echo "Number of Ideal Output TXT files: $no_of_ideal_output_files"

test_case_num=0
while [ $test_case_num -lt $no_of_test_cases ]; do
  echo "===================================="
  echo "Evaluating for Test case: $((test_case_num + 1))"
  #get the test_file name
  test_file="${test_files_list[$test_case_num]}"
  #get the ideal_output_file name
  ideal_output_file="${ideal_output_files_list[$test_case_num]}"
  #echo "Test TXT file: $test_file, Ideal Output TXT file: $ideal_output_file"
  #evaluate the student submitted file against the test_file
  #and generate temporary out.txt file
  evaluate "$test_case_num" "$submission_file" "$test_file"
  echo "===================================="
  #increment test_case_num variable
  test_case_num=$(($test_case_num + 1))
done

#round off the total_score to the nearest integer
total_score=$(echo "($total_score+0.5)/1" | bc)
echo "Marks scored: $total_score"

#provide remarks as per the total marks scored
if [ "$total_score" = $max_score ]; then
  echo "SUCCESS, Your code passed all the test cases."
  remarks="Congrats! You have successfully completed the assignment. Keep it up!"
  echo "Remarks: $remarks"
else
  echo "FAIL, Your code did not pass one or more test cases."
  remarks="Your code did not pass all of the test cases. Don't worry, keep trying until you get all of them passed!"
  echo "Remarks: $remarks"
fi
