#!/bin/bash

# set exit-on-error mode
set -e
# trap the exit signal instead of error(ERR) and handle it
# $? contains exit status of the last command executed
trap 'catch $? $LINENO' EXIT

# function to catch the exit signal and handle the exception
function catch() {
  #echo "catching EXIT!"
  if [ "$1" != "0" ]; then
    # error handling goes here
    #echo "Error $1 occurred on $2"
    #total_score=0
    echo "Marks scored: $total_score"
    remarks="EXCEPTION! Your code ran into an error! Debug your code."
    echo "Remarks: $remarks"
    # check whether temporary generated out.txt file exists or not
    [ -f out.txt ]
    if [ "$?" = 0 ]; then
      # delete the temporary generated out.txt file
      #echo "Return Code: $?, File out.txt exists!"
      rm -f out.txt
    else
      echo "Something went wrong, run this file again!"
      exit 1
    fi
  fi
}

# maximum score of the assignment
max_score=10
# to compute total marks scored after evaluation
total_score=0
# remarks to give as per the marks scored
remarks=""

# function to evaluate the student submitted file for "readScoreSheet" function
function evaluate_readScoreSheet() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  file_name=$( basename "$1" .py )
  #file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import $file_name as script; \
                  print(script.readScoreSheet('$2')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; \
                  print(script.readScoreSheet('$2')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" -eq 0 ]]; then
    # compare the out.txt file against the ideal_readScoreSheet_output_file
    # if the contents match, increment the total_score by readScoreSheet_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=2;$total_score+$readScoreSheet_func_weightage" | bc -l)
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "getTheTopper" function
function evaluate_getTheTopper() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  while IFS= read -r line; do
    line="\"$line\""
    # echo "$line"
    file_name=$( basename "$1" .py )
    #file_path=$( dirname "$1" )
    file_path="${1%/*}"
    curr_dir_path=$( pwd )
    if [[ "$file_path" == "$1" ]]; then
      python3 -c "import sys, ast; sys.path.append('$curr_dir_path'); import $file_name as script; \
                    print(script.getTheTopper(ast.literal_eval($line))); sys.path.remove('$curr_dir_path')" >> out.txt
    else
      python3 -c "import sys, ast; sys.path.append('$file_path'); import $file_name as script; \
                    print(script.getTheTopper(ast.literal_eval($line))); sys.path.remove('$file_path')" >> out.txt
    fi
  done < "$2"
  if [[ "$?" -eq 0 ]]; then
    # compare the out.txt file against the ideal_getTheTopper_output_file
    # if the contents match, increment the total_score by getTheTopper_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=2;$total_score+$getTheTopper_func_weightage" | bc -l)
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# take the student submitted file name from input arguments
submission_file="$1"

# find Test CSV Files and their count
cmd_find_test_files=$(ls utilities/a2_test_case**.csv)
test_files_list=($cmd_find_test_files)
# print file names of all test csv files
#echo "Test CSV file list names: ${test_files_list[@]}"
# print number of all test csv files
no_of_test_cases="${#test_files_list[@]}"
echo "Number of Test CSV files: $no_of_test_cases"

# compute the weightage of each test case
#echo $test_case_weightage
test_case_weightage=$(echo "scale=2;$max_score/$no_of_test_cases" | bc -l)

# compute the weightage of "readScoreSheet" function with 30%
readScoreSheet_func_weightage=$(echo "scale=2;$test_case_weightage*0.3" | bc -l)

# compute the weightage of "getTheTopper" function with 70%
getTheTopper_func_weightage=$(echo "scale=2;$test_case_weightage*0.7" | bc -l)

# find Ideal Output TXT Files and their count for "readScoreSheet" function
cmd_find_ideal_readScoreSheet_output_files=$(ls utilities/ideal_a2_readScoreSheet_test_case**.txt)
ideal_readScoreSheet_output_files_list=($cmd_find_ideal_readScoreSheet_output_files)
# print file names of all ideal "readScoreSheet" output txt files
# echo "Ideal 'readScoreSheet' Output txt file list names: ${ideal_readScoreSheet_output_files_list[@]}"
# print number of all ideal "readScoreSheet" output txt files
no_of_ideal_readScoreSheet_output_files="${#ideal_readScoreSheet_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_readScoreSheet_output_files"

# find Ideal Output TXT Files and their count for "getTheTopper" function
cmd_find_ideal_getTheTopper_output_files=$(ls utilities/ideal_a2_getTheTopper_test_case**.txt)
ideal_getTheTopper_output_files_list=($cmd_find_ideal_getTheTopper_output_files)
# print file names of all ideal "getTheTopper" output txt files
# echo "Ideal 'getTheTopper' Output txt file list names: ${ideal_getTheTopper_output_files_list[@]}"
# print number of all ideal "getTheTopper" output txt files
no_of_ideal_getTheTopper_output_files="${#ideal_getTheTopper_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_getTheTopper_output_files"

test_case_num=0
while [ $test_case_num -lt $no_of_test_cases ]; do
  echo "===================================="
  echo "Evaluating for Test case: $((test_case_num + 1))"
  import_word_count=$( cat "$1" | grep -w "import" | wc -l )
  import_csv_flag=$( cat "$1" | grep "import csv$" | wc -l )
  # echo "$import_word_count" "$import_csv_flag"
  if [[ "$import_word_count" -eq 1 && "$import_csv_flag" -eq 1 ]]; then
    # get the test_file name
    test_file="${test_files_list[$test_case_num]}"
    # get the ideal_readScoreSheet_output_file name
    ideal_readScoreSheet_output_file="${ideal_readScoreSheet_output_files_list[$test_case_num]}"
    #echo "Test CSV file: $test_file, Ideal 'readScoreSheet' Output TXT file: $ideal_readScoreSheet_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_readScoreSheet_output_file
    evaluate_readScoreSheet "$submission_file" "$test_file" "$ideal_readScoreSheet_output_file"
    # get the ideal_getTheTopper_output_file name
    ideal_getTheTopper_output_file="${ideal_getTheTopper_output_files_list[$test_case_num]}"
    #echo "Test CSV file: $test_file, Ideal 'getTheTopper' Output TXT file: $ideal_getTheTopper_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_getTheTopper_output_file
    evaluate_getTheTopper "$submission_file" "$ideal_readScoreSheet_output_file" "$ideal_getTheTopper_output_file"
  fi
  echo "Score up till Test case number $(($test_case_num + 1)) = $total_score"
  echo "===================================="
  # increment test_case_num variable
  test_case_num=$(($test_case_num + 1))
done

# round off the total_score to the nearest integer
total_score=$(echo "($total_score+0.5)/1" | bc)
echo "Marks scored: $total_score"

# provide remarks as per the total marks scored
if [[ "$total_score" -eq $max_score && "$import_word_count" -eq 1 && "$import_csv_flag" -eq 1 ]]; then
  echo "SUCCESS, Your code passed all the test cases."
  remarks="Congrats! You have successfully completed the assignment. Keep it up!"
  echo "Remarks: $remarks"
elif [[ "$total_score" -lt $max_score && "$import_word_count" -eq 1 && "$import_csv_flag" -eq 1 ]]; then
  echo "FAIL, Your code did not pass one or more test cases."
  remarks="Your code did not pass all of the test cases. Don't worry, keep trying until you get all of them passed!"
  echo "Remarks: $remarks"
else
  echo "FAIL, Your code consists of an extra import statement or is importing other module(s) apart from csv."
  remarks="Your code was not evaluated as it consists of an extra import statement or is importing other module(s) apart from csv!"
  echo "Remarks: $remarks"
fi
