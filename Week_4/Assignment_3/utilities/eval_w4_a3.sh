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

# function to evaluate the student submitted file for "readWorkSheet" function
function evaluate_readWorkSheet() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  file_name=$( basename "$1" .py )
  #file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import $file_name as script; \
                  print(script.readWorkSheet('$2')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; \
                  print(script.readWorkSheet('$2')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" -eq 0 ]]; then
    # compare the out.txt file against the ideal_readWorkSheet_output_file
    # if the contents match, increment the total_score by readWorkSheet_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=2;$total_score+$readWorkSheet_func_weightage" | bc -l)
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "calculateOfficeHrs" function
function evaluate_calculateOfficeHrs() {
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
                    print(script.calculateOfficeHrs(ast.literal_eval($line))); sys.path.remove('$curr_dir_path')" >> out.txt
    else
      python3 -c "import sys, ast; sys.path.append('$file_path'); import $file_name as script; \
                    print(script.calculateOfficeHrs(ast.literal_eval($line))); sys.path.remove('$file_path')" >> out.txt
    fi
  done < "$2"
  if [[ "$?" -eq 0 ]]; then
    # compare the out.txt file against the ideal_calculateOfficeHrs_output_file
    # if the contents match, increment the total_score by calculateOfficeHrs_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=2;$total_score+$calculateOfficeHrs_func_weightage" | bc -l)
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "writeOfficeWorkSheet" function
function evaluate_writeOfficeWorkSheet() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.csv file to compare with ideal output file ($3)
  while IFS= read -r line; do
    line="\"$line\""
    # echo "$line"
    file_name=$( basename "$1" .py )
    #file_path=$( dirname "$1" )
    file_path="${1%/*}"
    curr_dir_path=$( pwd )
    if [[ "$file_path" == "$1" ]]; then
      python3 -c "import sys, ast; sys.path.append('$curr_dir_path'); import $file_name as script; \
                    script.writeOfficeWorkSheet(ast.literal_eval($line), 'out.csv'); sys.path.remove('$curr_dir_path')"
    else
      python3 -c "import sys, ast; sys.path.append('$file_path'); import $file_name as script; \
                    script.writeOfficeWorkSheet(ast.literal_eval($line), 'out.csv'); sys.path.remove('$file_path')"
    fi
  done < "$2"
  if [[ "$?" -eq 0 ]]; then
    # compare the out.csv file against the ideal_writeOfficeWorkSheet_output_file
    # if the contents match, increment the total_score by writeOfficeWorkSheet_func_weightage
    if cmp -s out.csv "$3"; then
      total_score=$(echo "scale=2;$total_score+$writeOfficeWorkSheet_func_weightage" | bc -l)
    fi
    # delete the temporary generated out.csv file
    rm -f out.csv
  else
    rm -f out.csv
  fi
}

# take the student submitted file name from input arguments
submission_file="$1"

# find Test CSV Files and their count
cmd_find_test_files=$(ls utilities/a3_test_case**.csv)
test_files_list=($cmd_find_test_files)
# print file names of all test csv files
#echo "Test CSV file list names: ${test_files_list[@]}"
# print number of all test csv files
no_of_test_cases="${#test_files_list[@]}"
echo "Number of Test CSV files: $no_of_test_cases"

# compute the weightage of each test case
#echo $test_case_weightage
test_case_weightage=$(echo "scale=2;$max_score/$no_of_test_cases" | bc -l)

# compute the weightage of "readWorkSheet" function with 40%
readWorkSheet_func_weightage=$(echo "scale=2;$test_case_weightage*0.4" | bc -l)

# compute the weightage of "calculateOfficeHrs" function with 20%
calculateOfficeHrs_func_weightage=$(echo "scale=2;$test_case_weightage*0.2" | bc -l)

# compute the weightage of "writeOfficeWorkSheet" function with 40%
writeOfficeWorkSheet_func_weightage=$(echo "scale=2;$test_case_weightage*0.4" | bc -l)

# find Ideal Output TXT Files and their count for "readWorkSheet" function
cmd_find_ideal_readWorkSheet_output_files=$(ls utilities/ideal_a3_readWorkSheet_test_case**.txt)
ideal_readWorkSheet_output_files_list=($cmd_find_ideal_readWorkSheet_output_files)
# print file names of all ideal "readWorkSheet" output txt files
# echo "Ideal 'readWorkSheet' Output txt file list names: ${ideal_readWorkSheet_output_files_list[@]}"
# print number of all ideal "readWorkSheet" output txt files
no_of_ideal_readWorkSheet_output_files="${#ideal_readWorkSheet_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_readWorkSheet_output_files"

# find Ideal Output TXT Files and their count for "calculateOfficeHrs" function
cmd_find_ideal_calculateOfficeHrs_output_files=$(ls utilities/ideal_a3_calculateOfficeHrs_test_case**.txt)
ideal_calculateOfficeHrs_output_files_list=($cmd_find_ideal_calculateOfficeHrs_output_files)
# print file names of all ideal "calculateOfficeHrs" output txt files
# echo "Ideal 'calculateOfficeHrs' Output txt file list names: ${ideal_calculateOfficeHrs_output_files_list[@]}"
# print number of all ideal "calculateOfficeHrs" output txt files
no_of_ideal_calculateOfficeHrs_output_files="${#ideal_calculateOfficeHrs_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_calculateOfficeHrs_output_files"

# find Ideal Output CSV Files and their count for "writeOfficeWorkSheet" function
cmd_find_ideal_writeOfficeWorkSheet_output_files=$(ls utilities/ideal_a3_writeOfficeWorkSheet_test_case**.csv)
ideal_writeOfficeWorkSheet_output_files_list=($cmd_find_ideal_writeOfficeWorkSheet_output_files)
# print file names of all ideal "writeOfficeWorkSheet" output csv files
# echo "Ideal 'writeOfficeWorkSheet' Output csv file list names: ${ideal_writeOfficeWorkSheet_output_files_list[@]}"
# print number of all ideal "writeOfficeWorkSheet" output csv files
no_of_ideal_writeOfficeWorkSheet_output_files="${#ideal_writeOfficeWorkSheet_output_files_list[@]}"
# echo "Number of Ideal Output CSV files: $no_of_ideal_writeOfficeWorkSheet_output_files"

test_case_num=0
while [ $test_case_num -lt $no_of_test_cases ]; do
  echo "===================================="
  echo "Evaluating for Test case: $((test_case_num + 1))"
  import_word_count=$( cat "$1" | grep -w "import" | wc -l )
  import_csv_flag=$( cat "$1" | grep "import csv$" | wc -l )
  import_datetime_flag=$( cat "$1" | grep "from datetime import datetime as dt$" | wc -l )
  # echo "$import_word_count" "$import_csv_flag" "$import_datetime_flag"
  if [[ "$import_word_count" -eq 2 && "$import_csv_flag" -eq 1 && "$import_datetime_flag" -eq 1 ]]; then
    # get the test_file name
    test_file="${test_files_list[$test_case_num]}"
    # get the ideal_readWorkSheet_output_file name
    ideal_readWorkSheet_output_file="${ideal_readWorkSheet_output_files_list[$test_case_num]}"
    #echo "Test CSV file: $test_file, Ideal 'readWorkSheet' Output TXT file: $ideal_readWorkSheet_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_readWorkSheet_output_file
    evaluate_readWorkSheet "$submission_file" "$test_file" "$ideal_readWorkSheet_output_file"
    # get the ideal_calculateOfficeHrs_output_file name
    ideal_calculateOfficeHrs_output_file="${ideal_calculateOfficeHrs_output_files_list[$test_case_num]}"
    #echo "Test CSV file: $test_file, Ideal 'calculateOfficeHrs' Output TXT file: $ideal_calculateOfficeHrs_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_calculateOfficeHrs_output_file
    evaluate_calculateOfficeHrs "$submission_file" "$ideal_readWorkSheet_output_file" "$ideal_calculateOfficeHrs_output_file"
    # get the ideal_writeOfficeWorkSheet_output_file name
    ideal_writeOfficeWorkSheet_output_file="${ideal_writeOfficeWorkSheet_output_files_list[$test_case_num]}"
    #echo "Test CSV file: $test_file, Ideal 'writeOfficeWorkSheet' Output CSV file: $ideal_writeOfficeWorkSheet_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.csv file to compare with ideal_writeOfficeWorkSheet_output_file
    evaluate_writeOfficeWorkSheet "$submission_file" "$ideal_readWorkSheet_output_file" "$ideal_writeOfficeWorkSheet_output_file"
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
if [[ "$total_score" -eq $max_score && "$import_word_count" -eq 2 && "$import_csv_flag" -eq 1 && "$import_datetime_flag" -eq 1 ]]; then
  echo "SUCCESS, Your code passed all the test cases."
  remarks="Congrats! You have successfully completed the assignment. Keep it up!"
  echo "Remarks: $remarks"
elif [[ "$total_score" -lt $max_score && "$import_word_count" -eq 2 && "$import_csv_flag" -eq 1 && "$import_datetime_flag" -eq 1 ]]; then
  echo "FAIL, Your code did not pass one or more test cases."
  remarks="Your code did not pass all of the test cases. Don't worry, keep trying until you get all of them passed!"
  echo "Remarks: $remarks"
else
  echo "FAIL, Your code consists of an extra import statement or is importing other module(s) apart from csv, datetime."
  remarks="Your code was not evaluated as it consists of an extra import statement or is importing other module(s) apart from csv, datetime!"
  echo "Remarks: $remarks"
fi
