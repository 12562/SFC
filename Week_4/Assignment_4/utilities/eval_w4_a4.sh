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

# function to evaluate the student submitted file for "readMarkSheet" function
function evaluate_readMarkSheet() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  file_name=$( basename "$1" .py )
  #file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import $file_name as script; \
                  print(script.readMarkSheet('$2')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; \
                  print(script.readMarkSheet('$2')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" -eq 0 ]]; then
    # compare the out.txt file against the ideal_readMarkSheet_output_file
    # if the contents match, increment the total_score by readMarkSheet_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=2;$total_score+$readMarkSheet_func_weightage" | bc -l)
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "generateGradeCard" function
function evaluate_generateGradeCard() {
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
                    print(script.generateGradeCard(ast.literal_eval($line))); sys.path.remove('$curr_dir_path')" >> out.txt
    else
      python3 -c "import sys, ast; sys.path.append('$file_path'); import $file_name as script; \
                    print(script.generateGradeCard(ast.literal_eval($line))); sys.path.remove('$file_path')" >> out.txt
    fi
  done < "$2"
  if [[ "$?" -eq 0 ]]; then
    # compare the out.txt file against the ideal_generateGradeCard_output_file
    # if the contents match, increment the total_score by generateGradeCard_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=2;$total_score+$generateGradeCard_func_weightage" | bc -l)
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
cmd_find_test_files=$(ls utilities/a4_test_case**.csv)
test_files_list=($cmd_find_test_files)
# print file names of all test csv files
#echo "Test CSV file list names: ${test_files_list[@]}"
# print number of all test csv files
no_of_test_cases="${#test_files_list[@]}"
echo "Number of Test CSV files: $no_of_test_cases"

# compute the weightage of each test case
#echo $test_case_weightage
test_case_weightage=$(echo "scale=2;$max_score/$no_of_test_cases" | bc -l)

# compute the weightage of "readMarkSheet" function with 40%
readMarkSheet_func_weightage=$(echo "scale=2;$test_case_weightage*0.4" | bc -l)

# compute the weightage of "generateGradeCard" function with 60%
generateGradeCard_func_weightage=$(echo "scale=2;$test_case_weightage*0.6" | bc -l)

# find Ideal Output TXT Files and their count for "readMarkSheet" function
cmd_find_ideal_readMarkSheet_output_files=$(ls utilities/ideal_a4_readMarkSheet_test_case**.txt)
ideal_readMarkSheet_output_files_list=($cmd_find_ideal_readMarkSheet_output_files)
# print file names of all ideal "readMarkSheet" output txt files
# echo "Ideal 'readMarkSheet' Output txt file list names: ${ideal_readMarkSheet_output_files_list[@]}"
# print number of all ideal "readMarkSheet" output txt files
no_of_ideal_readMarkSheet_output_files="${#ideal_readMarkSheet_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_readMarkSheet_output_files"

# find Ideal Output TXT Files and their count for "generateGradeCard" function
cmd_find_ideal_generateGradeCard_output_files=$(ls utilities/ideal_a4_generateGradeCard_test_case**.txt)
ideal_generateGradeCard_output_files_list=($cmd_find_ideal_generateGradeCard_output_files)
# print file names of all ideal "generateGradeCard" output txt files
# echo "Ideal 'generateGradeCard' Output txt file list names: ${ideal_generateGradeCard_output_files_list[@]}"
# print number of all ideal "generateGradeCard" output txt files
no_of_ideal_generateGradeCard_output_files="${#ideal_generateGradeCard_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_generateGradeCard_output_files"

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
    # get the ideal_readMarkSheet_output_file name
    ideal_readMarkSheet_output_file="${ideal_readMarkSheet_output_files_list[$test_case_num]}"
    #echo "Test CSV file: $test_file, Ideal 'readMarkSheet' Output TXT file: $ideal_readMarkSheet_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_readMarkSheet_output_file
    evaluate_readMarkSheet "$submission_file" "$test_file" "$ideal_readMarkSheet_output_file"
    # get the ideal_generateGradeCard_output_file name
    ideal_generateGradeCard_output_file="${ideal_generateGradeCard_output_files_list[$test_case_num]}"
    #echo "Test CSV file: $test_file, Ideal 'generateGradeCard' Output TXT file: $ideal_generateGradeCard_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_generateGradeCard_output_file
    evaluate_generateGradeCard "$submission_file" "$ideal_readMarkSheet_output_file" "$ideal_generateGradeCard_output_file"
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
