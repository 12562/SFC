#!/bin/bash

#set exit-on-error mode
set -e

#test script begins
echo "Running tests..."
echo

#function to evaluate the student submitted file
function evaluate() {
  #run the student submitted file ($2) against the test_file ($3)
  #and generate temporary out.txt file
  awk -f "$2" "$3" > out.txt
  if [ "$?" -eq 0 ]; then
    echo "Pass => Program executed correctly."
    echo
    #compare the out.txt file against the ideal_output_file
    if cmp -s out.txt "$ideal_output_file"; then
      echo "Pass => Output is correct!"
      echo "Test case number $(($1 + 1)): PASS"
    else
      echo "Fail => Expected output is: "
      cat "$ideal_output_file"
      echo
      echo "But got the output: "
      cat out.txt
      echo
      echo "Test case number $(($1 + 1)): FAIL"
      rm -f out.txt
      exit 1
    fi
    #delete the temporary generated out.txt file
    rm -f out.txt
  else
    echo "Fail => Program did not execute correctly."
    echo
    exit 1
  fi
}

#take the student submitted file name from input arguments
submission_file=$1

#find Test CSV Files and their count
cmd_find_test_files=$(ls w3_a1_test_case**.csv)
test_files_list=($cmd_find_test_files)
no_of_test_cases="${#test_files_list[@]}"

#find Ideal Output TXT Files and their count
cmd_find_ideal_output_files=$(ls ideal_w3_a1_test_case**.txt)
ideal_output_files_list=($cmd_find_ideal_output_files)
no_of_ideal_output_files="${#ideal_output_files_list[@]}"

test_case_num=0
while [ $test_case_num -lt $no_of_test_cases ]; do
  echo "===================================="
  echo "Evaluating for Test case: $((test_case_num + 1))"
  echo
  #get the test_file name
  test_file="${test_files_list[$test_case_num]}"
  #get the ideal_output_file name
  ideal_output_file="${ideal_output_files_list[$test_case_num]}"
  #evaluate the student submitted file against the test_file
  #and generate temporary out.txt file
  evaluate "$test_case_num" "$submission_file" "$test_file"
  echo "===================================="
  #increment test_case_num variable
  test_case_num=$(($test_case_num + 1))
done

echo
echo "Congrats! All test cases PASSED."

exit 0
