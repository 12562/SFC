#!/bin/bash

# set exit-on-error mode
# set -e
# trap the exit signal instead of error(ERR) and handle it
# $? contains exit status of the last command executed
# trap 'catch $? $LINENO' EXIT

# function to catch the exit signal and handle the exception
function catch() {
  # echo "catching EXIT!"
  if [ "$1" != "0" ]; then
    # error handling goes here
    # echo "Error $1 occurred on $2"
    # total_score=0
    echo "Marks scored: $total_score"
    remarks="EXCEPTION! Your code ran into an error! Debug your code."
    echo "Remarks: $remarks"
    # check whether temporary generated out.txt file exists or not
    [ -f out.txt ]
    if [ "$?" = 0 ]; then
      # delete the temporary generated out.txt file
      # echo "Return Code: $?, File out.txt exists!"
      rm -f out.txt
    else
      echo "Something went wrong, run this file again!"
      exit 1
    fi
  fi
}

# maximum score of the assignment
max_score=20
# to compute total marks scored after evaluation
total_score=0
# remarks to give as per the marks scored
remarks=""

# order of sub-parser commands in test case input TXT files
executeShellCommands=1
executePwdCmd=2
executeDateCmd=3
executeCatCmd=4
executeHeadCmd=5
executeTailCmd=6

# function to evaluate the student submitted file for "executeShellCommands" function
function evaluate_executeShellCommands() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  line=$( sed -n "$executeShellCommands"p "$2" )
  # echo "$line"
  # file_name=$( basename "$1" .py )
  # file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  # python3 "$1" $line >> out.txt
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" = 0 ]]; then
    # compare the out.txt file against the ideal_executeShellCommands_output_file
    # if the contents match, increment the total_score by executeShellCommands_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=3;$total_score+$executeShellCommands_func_weightage" | bc -l)
    else
      if [[ "$4" -eq 0 ]]; then
        test_executeShellCommands_remarks="The description or epilog of program and/or the title for sub-parser and/or the help message for sub-praser commands (pwd,date,cat,head,tail) is/are defined incorrectly."
        # echo "$test_executeShellCommands_remarks"
      elif [[ "$4" -eq 1 || "$4" -eq 5 || "$4" -eq 7 ]]; then
        test_executeShellCommands_remarks="Make sure that there are no positional arguments defined for the program apart from the sub-parser commands (pwd,date,cat,head,tail)."
        # echo "$test_executeShellCommands_remarks"
      elif [[ "$4" -eq 2 || "$4" -eq 3 || "$4" -eq 4 || "$4" -eq 6 ]]; then
        test_executeShellCommands_remarks="The optional argument should only be default '--help' or '-h', and your code should not print help message for '--he' or '--hel' or so on."
        # echo "$test_executeShellCommands_remarks"
      fi
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "executePwdCmd" function
function evaluate_executePwdCmd() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  line=$( sed -n "$executePwdCmd"p "$2" )
  # echo "$line"
  # file_name=$( basename "$1" .py )
  # file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  # python3 "$1" $line >> out.txt
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" = 0 ]]; then
    # modifiying the ideal_executePwdCmd_output_file for running only 'python3 w6_activity1.py pwd'
    if [[ "$4" -eq $(echo $executePwdCmd-1 | bc -l) ]]; then
      echo "$curr_dir_path" > "$3"
      echo >> "$3"
    fi
    # compare the out.txt file against the ideal_executePwdCmd_output_file
    # if the contents match, increment the total_score by executePwdCmd_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=3;$total_score+$executePwdCmd_func_weightage" | bc -l)
    else
      if [[ "$4" -eq 0 || "$4" -eq 3 || "$4" -eq 4 ]]; then
        test_executePwdCmd_remarks="For sub-parser command 'pwd', your code should print help message for '--he' or '--hel' or so on."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 1 ]]; then
        test_executePwdCmd_remarks="The path of current/working directory provided by your code is found incorrect."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 5 ]]; then
        test_executePwdCmd_remarks="Make sure that the sub-parser command is defined as 'pwd' and not 'pw' or so on."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 2 || "$4" -eq 6 || "$4" -eq 7 ]]; then
        test_executePwdCmd_remarks="Make sure that there are no positional arguments defined for the sub-parser command 'pwd' apart from the default optional argument '--help' or '-h'."
        # echo "$test_executePwdCmd_remarks"
      fi
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "executeDateCmd" function
function evaluate_executeDateCmd() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  line=$( sed -n "$executeDateCmd"p "$2" )
  # echo "$line"
  # file_name=$( basename "$1" .py )
  # file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  # python3 "$1" $line >> out.txt
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" = 0 ]]; then
    # modifiying the ideal_executeDateCmd_output_file for running only 'python3 w6_activity1.py date'
    if [[ "$4" -eq $(echo $executeDateCmd-2 | bc -l) ]]; then
      echo $(date +%x) > "$3"
      echo >> "$3"
    fi
    # compare the out.txt file against the ideal_executeDateCmd_output_file
    # if the contents match, increment the total_score by executeDateCmd_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=3;$total_score+$executeDateCmd_func_weightage" | bc -l)
    else
      if [[ "$4" -eq 0 || "$4" -eq 3 || "$4" -eq 4 ]]; then
        test_executeDateCmd_remarks="For sub-parser command 'date', your code should print help message for '--he' or '--hel' or so on."
        # echo "$test_executeDateCmd_remarks"
      elif [[ "$4" -eq 1 ]]; then
        test_executePwdCmd_remarks="The date of current day provided by your code is found incorrect or the format of date is not as expected."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 5 ]]; then
        test_executePwdCmd_remarks="Make sure that the sub-parser command is defined as 'date' and not 'dat' or so on."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 2 || "$4" -eq 6 || "$4" -eq 7 ]]; then
        test_executeDateCmd_remarks="Make sure that there are no positional arguments defined for the sub-parser command 'date' apart from the default optional argument '--help' or '-h'."
        # echo "$test_executeDateCmd_remarks"
      fi
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "executeCatCmd" function
function evaluate_executeCatCmd() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  line=$( sed -n "$executeCatCmd"p "$2" )
  # echo "$line"
  # file_name=$( basename "$1" .py )
  # file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  # python3 "$1" $line >> out.txt
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" = 0 ]]; then
    # compare the out.txt file against the ideal_executeCatCmd_output_file
    # if the contents match, increment the total_score by executeCatCmd_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=3;$total_score+$executeCatCmd_func_weightage" | bc -l)
    else
      if [[ "$4" -eq 0 || "$4" -eq 1 ]]; then
        test_executeCatCmd_remarks="Make sure that positional argument 'file' is defined correctly for sub-parser command 'cat' with help message and it should be able to take more than 1 input for 'file'."
        # echo "$test_executeCatCmd_remarks"
      elif [[ "$4" -eq 2 || "$4" -eq 3 ]]; then
        test_executePwdCmd_remarks="The contents of the file input printed to STDOUT are found to be incorrect, make sure each line of a file is read and printed correctly. Also check for more than 1 file input, compare your code output with actual 'cat' command."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 4 || "$4" -eq 5 || "$4" -eq 6 || "$4" -eq 7 ]]; then
        test_executeCatCmd_remarks="Make sure that your code is able to print appropriate message when a non-existing file name or an existing directory name is provided as input."
        # echo "$test_executeCatCmd_remarks"
      fi
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "executeHeadCmd" function
function evaluate_executeHeadCmd() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  line=$( sed -n "$executeHeadCmd"p "$2" )
  # echo "$line"
  # file_name=$( basename "$1" .py )
  # file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  # python3 "$1" $line >> out.txt
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" = 0 ]]; then
    # compare the out.txt file against the ideal_executeHeadCmd_output_file
    # if the contents match, increment the total_score by executeHeadCmd_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=3;$total_score+$executeHeadCmd_func_weightage" | bc -l)
    else
      if [[ "$4" -eq 0 || "$4" -eq 1 ]]; then
        test_executeHeadCmd_remarks="Make sure that positional argument 'file' and optional arguments '-n/--lines' (with storing of one input of an integer NUM specifiying number of lines to be read and printed) and '-v/--verbose' are defined correctly for sub-parser command 'head' with respective help message."
        # test_executeHeadCmd_remarks="The square of positional argument (N) is calculated incorrectly or the type conversion of N to integer is not done."
        # echo "$test_executeHeadCmd_remarks"
      elif [[ "$4" -eq 2 || "$4" -eq 3 ]]; then
        test_executePwdCmd_remarks="The contents of the first 10 lines of a file input printed to STDOUT are found to be incorrect, make sure each line of a file is read and printed correctly. Also check your code output for printing first NUM lines of a file when provided with '-n/--lines', compare your code output with actual 'head' command."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 4 || "$4" -eq 5 ]]; then
        test_executeHeadCmd_remarks="Make sure that your code is able to print the file name as header with the complete path provided as input to 'head' in the required format when '-v/--verbose' is passed along with '-n/--lines'."
        # echo "$test_executeHeadCmd_remarks"
      elif [[ "$4" -eq 6 ]]; then
        test_executeHeadCmd_remarks="Make sure that the NUM argument passed with optional argument '-n/--lines' is type converted to integer correctly."
        # echo test_executeHeadCmd_remarks
      elif [[ "$4" -eq 7 ]]; then
        test_executeHeadCmd_remarks="Make sure that your code is able to print appropriate message when a non-existing file name or an existing directory name is provided as input."
        # echo test_executeHeadCmd_remarks
      # elif [[ "$4" -eq 1 ]]; then
      #   test_executeHeadCmd_remarks="The cube of positional argument (N) is calculated incorrectly or the optional argument name is defined incorrectly, short-name should be '-c' and long-name should be '--cube'."
      #   # echo "$test_executeHeadCmd_remarks"
      # elif [[ "$4" -eq 4 ]]; then
      #   test_executeHeadCmd_remarks="The description or epilog of program and/or the help message for position argument (N) and/or optional argument ('-c', '--cube') is defined incorrectly."
      #   # echo "$test_executeHeadCmd_remarks"
      fi
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for "executeTailCmd" function
function evaluate_executeTailCmd() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  line=$( sed -n "$executeTailCmd"p "$2" )
  # echo "$line"
  # file_name=$( basename "$1" .py )
  # file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  # python3 "$1" $line >> out.txt
  if [[ "$file_path" == "$1" ]]; then
    python3 -c "import sys; sys.path.append('$curr_dir_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$curr_dir_path')" >> out.txt
  else
    python3 -c "import sys; sys.path.append('$file_path'); import subprocess; \
                  out = subprocess.run('python3 $1 $line', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                  print(out.stdout.decode('utf-8')); sys.path.remove('$file_path')" >> out.txt
  fi
  if [[ "$?" = 0 ]]; then
    # compare the out.txt file against the ideal_executeTailCmd_output_file
    # if the contents match, increment the total_score by executeTailCmd_func_weightage
    if cmp -s out.txt "$3"; then
      total_score=$(echo "scale=3;$total_score+$executeTailCmd_func_weightage" | bc -l)
    else
      if [[ "$4" -eq 0 || "$4" -eq 1 ]]; then
        test_executeTailCmd_remarks="Make sure that positional argument 'file' and optional arguments '-n/--lines' (with storing of one input of an integer NUM specifiying number of lines to be read and printed) and '-v/--verbose' are defined correctly for sub-parser command 'tail' with respective help message."
        # echo "$test_executeTailCmd_remarks"
      elif [[ "$4" -eq 2 || "$4" -eq 3 ]]; then
        test_executePwdCmd_remarks="The contents of the last 10 lines of a file input printed to STDOUT are found to be incorrect, make sure each line of a file is read and printed correctly. Also check your code output for printing last NUM lines of a file when provided with '-n/--lines', compare your code output with actual 'tail' command."
        # echo "$test_executePwdCmd_remarks"
      elif [[ "$4" -eq 4 || "$4" -eq 5 ]]; then
        test_executeTailCmd_remarks="Make sure that your code is able to print the file name as header with the complete path provided as input to 'tail' in the required format when '-v/--verbose' is passed along with '-n/--lines'."
        # echo "$test_executeTailCmd_remarks"
      elif [[ "$4" -eq 6 ]]; then
        test_executeTailCmd_remarks="Make sure that the NUM argument passed with optional argument '-n/--lines' is type converted to integer correctly."
        # echo test_executeTailCmd_remarks
      elif [[ "$4" -eq 7 ]]; then
        test_executeTailCmd_remarks="Make sure that your code is able to print appropriate message when a non-existing file name or an existing directory name is provided as input."
        # echo test_executeTailCmd_remarks
      fi
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# take the student submitted file name from input arguments
submission_file=$1

# find Test TXT Files and their count
cmd_find_test_files=$(ls utilities/a1_test_case**.txt)
test_files_list=($cmd_find_test_files)
# print file names of all test txt files
# echo "Test TXT file list names: ${test_files_list[@]}"
# print number of all test txt files
no_of_test_cases="${#test_files_list[@]}"
echo "Number of Test TXT files: $no_of_test_cases"

# compute the weightage of each test case
test_case_weightage=$(echo "scale=3;$max_score/$no_of_test_cases" | bc -l)
# echo $test_case_weightage

# compute the weightage of "executeShellCommands" function with 10%
executeShellCommands_func_weightage=$(echo "scale=3;$test_case_weightage*0.1" | bc -l)

# compute the weightage of "executePwdCmd" function with 10%
executePwdCmd_func_weightage=$(echo "scale=3;$test_case_weightage*0.1" | bc -l)

# compute the weightage of "executeDateCmd" function with 10%
executeDateCmd_func_weightage=$(echo "scale=3;$test_case_weightage*0.1" | bc -l)

# compute the weightage of "executeCatCmd" function with 20%
executeCatCmd_func_weightage=$(echo "scale=3;$test_case_weightage*0.2" | bc -l)

# compute the weightage of "executeHeadCmd" function with 25%
executeHeadCmd_func_weightage=$(echo "scale=3;$test_case_weightage*0.25" | bc -l)

# compute the weightage of "executeTailCmd" function with 25%
executeTailCmd_func_weightage=$(echo "scale=3;$test_case_weightage*0.25" | bc -l)

# find Ideal Output TXT Files and their count for "executeShellCommands" function
cmd_find_ideal_executeShellCommands_output_files=$(ls utilities/ideal_a1_executeShellCommands_test_case**.txt)
ideal_executeShellCommands_output_files_list=($cmd_find_ideal_executeShellCommands_output_files)
# print file names of all ideal "executeShellCommands" output txt files
# echo "Ideal 'executeShellCommands' Output txt file list names: ${ideal_executeShellCommands_output_files_list[@]}"
# print number of all ideal "executeShellCommands" output txt files
# no_of_ideal_executeShellCommands_output_files="${#ideal_executeShellCommands_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_executeShellCommands_output_files"

# find Ideal Output TXT Files and their count for "executePwdCmd" function
cmd_find_ideal_executePwdCmd_output_files=$(ls utilities/ideal_a1_executePwdCmd_test_case**.txt)
ideal_executePwdCmd_output_files_list=($cmd_find_ideal_executePwdCmd_output_files)
# print file names of all ideal "executePwdCmd" output txt files
# echo "Ideal 'executePwdCmd' Output txt file list names: ${ideal_executePwdCmd_output_files_list[@]}"
# print number of all ideal "executePwdCmd" output txt files
# no_of_ideal_executePwdCmd_output_files="${#ideal_executePwdCmd_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_executePwdCmd_output_files"

# find Ideal Output TXT Files and their count for "executeDateCmd" function
cmd_find_ideal_executeDateCmd_output_files=$(ls utilities/ideal_a1_executeDateCmd_test_case**.txt)
ideal_executeDateCmd_output_files_list=($cmd_find_ideal_executeDateCmd_output_files)
# print file names of all ideal "executeDateCmd" output txt files
# echo "Ideal 'executeDateCmd' Output txt file list names: ${ideal_executeDateCmd_output_files_list[@]}"
# print number of all ideal "executeDateCmd" output txt files
# no_of_ideal_executeDateCmd_output_files="${#ideal_executeDateCmd_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_executeDateCmd_output_files"

# find Ideal Output TXT Files and their count for "executeCatCmd" function
cmd_find_ideal_executeCatCmd_output_files=$(ls utilities/ideal_a1_executeCatCmd_test_case**.txt)
ideal_executeCatCmd_output_files_list=($cmd_find_ideal_executeCatCmd_output_files)
# print file names of all ideal "executeCatCmd" output txt files
# echo "Ideal 'executeCatCmd' Output txt file list names: ${ideal_executeCatCmd_output_files_list[@]}"
# print number of all ideal "executeCatCmd" output txt files
# no_of_ideal_executeCatCmd_output_files="${#ideal_executeCatCmd_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_executeCatCmd_output_files"

# find Ideal Output TXT Files and their count for "executeHeadCmd" function
cmd_find_ideal_executeHeadCmd_output_files=$(ls utilities/ideal_a1_executeHeadCmd_test_case**.txt)
ideal_executeHeadCmd_output_files_list=($cmd_find_ideal_executeHeadCmd_output_files)
# print file names of all ideal "executeHeadCmd" output txt files
# echo "Ideal 'executeHeadCmd' Output txt file list names: ${ideal_executeHeadCmd_output_files_list[@]}"
# print number of all ideal "executeHeadCmd" output txt files
# no_of_ideal_executeHeadCmd_output_files="${#ideal_executeHeadCmd_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_executeHeadCmd_output_files"

# find Ideal Output TXT Files and their count for "executeTailCmd" function
cmd_find_ideal_executeTailCmd_output_files=$(ls utilities/ideal_a1_executeTailCmd_test_case**.txt)
ideal_executeTailCmd_output_files_list=($cmd_find_ideal_executeTailCmd_output_files)
# print file names of all ideal "executeTailCmd" output txt files
# echo "Ideal 'executeTailCmd' Output txt file list names: ${ideal_executeTailCmd_output_files_list[@]}"
# print number of all ideal "executeTailCmd" output txt files
# no_of_ideal_executeTailCmd_output_files="${#ideal_executeTailCmd_output_files_list[@]}"
# echo "Number of Ideal Output TXT files: $no_of_ideal_executeTailCmd_output_files"

test_case_num=0
while [ $test_case_num -lt $no_of_test_cases ]; do
  echo "===================================="
  echo "Evaluating for Test case: $((test_case_num + 1))"
  import_word_count=$( cat "$1" | grep -w "import" | wc -l )
  import_argparse_flag=$( cat "$1" | grep "import argparse$" | wc -l )
  import_os_flag=$( cat "$1" | grep "import os$" | wc -l )
  import_datetime_flag=$( cat "$1" | grep "from datetime import datetime$" | wc -l )
  os_system_flag=$( cat "$1" | grep "os.system" | wc -l )
  os_popen_flag=$( cat "$1" | grep "os.popen" | wc -l )
  main_func_line_no=$( cat "$1" | grep -nwo 'if __name__ == "__main__":$' "$1" | sed 's/:.*//g' )
  func_call_line_no=$( cat "$1" | grep -nwo "executeShellCommands()$" "$1" | sed 's/:.*//g' )
  diff_line_no=$(( $func_call_line_no - $main_func_line_no ))
  if [[ "$import_word_count" -eq 3 && "$import_argparse_flag" -eq 1 && "$import_os_flag" -eq 1 && "$import_datetime_flag" -eq 1 && 
        "$diff_line_no" -eq 3 && "$os_system_flag" -eq 0 && "$os_popen_flag" -eq 0 ]]; then
    # get the test_file name
    test_file="${test_files_list[$test_case_num]}"
    # get the ideal_executeShellCommands_output_file name
    ideal_executeShellCommands_output_file="${ideal_executeShellCommands_output_files_list[$test_case_num]}"
    #echo "Test TXT file: $test_file, Ideal 'executeShellCommands' Output TXT file: $ideal_executeShellCommands_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_executeShellCommands_output_file
    evaluate_executeShellCommands "$submission_file" "$test_file" "$ideal_executeShellCommands_output_file" "$test_case_num"
    # get the ideal_executePwdCmd_output_file name
    ideal_executePwdCmd_output_file="${ideal_executePwdCmd_output_files_list[$test_case_num]}"
    #echo "Test TXT file: $test_file, Ideal 'executePwdCmd' Output TXT file: $ideal_executePwdCmd_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_executePwdCmd_output_file
    evaluate_executePwdCmd "$submission_file" "$test_file" "$ideal_executePwdCmd_output_file" "$test_case_num"
    # get the ideal_executeDateCmd_output_file name
    ideal_executeDateCmd_output_file="${ideal_executeDateCmd_output_files_list[$test_case_num]}"
    #echo "Test TXT file: $test_file, Ideal 'executeDateCmd' Output TXT file: $ideal_executeDateCmd_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_executeDateCmd_output_file
    evaluate_executeDateCmd "$submission_file" "$test_file" "$ideal_executeDateCmd_output_file" "$test_case_num"
    # get the ideal_executeCatCmd_output_file name
    ideal_executeCatCmd_output_file="${ideal_executeCatCmd_output_files_list[$test_case_num]}"
    #echo "Test TXT file: $test_file, Ideal 'executeCatCmd' Output TXT file: $ideal_executeCatCmd_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_executeCatCmd_output_file
    evaluate_executeCatCmd "$submission_file" "$test_file" "$ideal_executeCatCmd_output_file" "$test_case_num"
    # get the ideal_executeHeadCmd_output_file name
    ideal_executeHeadCmd_output_file="${ideal_executeHeadCmd_output_files_list[$test_case_num]}"
    #echo "Test TXT file: $test_file, Ideal 'executeHeadCmd' Output TXT file: $ideal_executeHeadCmd_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_executeHeadCmd_output_file
    evaluate_executeHeadCmd "$submission_file" "$test_file" "$ideal_executeHeadCmd_output_file" "$test_case_num"
    # get the ideal_executeTailCmd_output_file name
    ideal_executeTailCmd_output_file="${ideal_executeTailCmd_output_files_list[$test_case_num]}"
    #echo "Test TXT file: $test_file, Ideal 'executeTailCmd' Output TXT file: $ideal_executeTailCmd_output_file"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_executeTailCmd_output_file
    evaluate_executeTailCmd "$submission_file" "$test_file" "$ideal_executeTailCmd_output_file" "$test_case_num"
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
if [[ "$total_score" -eq $max_score && "$import_word_count" -eq 3 && "$import_argparse_flag" -eq 1 && "$import_os_flag" -eq 1 && 
        "$import_datetime_flag" -eq 1 && "$diff_line_no" -eq 3 && "$os_system_flag" -eq 0 && "$os_popen_flag" -eq 0 ]]; then
  echo "SUCCESS, Your code passed all the test cases."
  remarks="Congrats! You have successfully completed the assignment. Keep it up!"
elif [[ "$total_score" -lt $max_score && "$import_word_count" -eq 3 && "$import_argparse_flag" -eq 1 && "$import_os_flag" -eq 1 && 
        "$import_datetime_flag" -eq 1 && "$diff_line_no" -eq 3 && "$os_system_flag" -eq 0 && "$os_popen_flag" -eq 0 ]]; then
  echo "FAIL, Your code did not pass one or more test cases."
  remarks="Your code did not pass all of the test cases. You need not worry, keep trying until you get all of them passed!"
else
  echo "FAIL, Your code consists of an extra import statement or is importing other module(s) apart from argparse, os and datetime. Also check whether you are not using os.system or os.popen function call in your code."
  remarks="Your code was not evaluated as it consists of an extra import statement or is importing other module(s) apart from argparse, os and datetime! Also check whether you are not using os.system or os.popen function call in your code!"
fi

if [[ ${#test_executeShellCommands_remarks} -gt 0 ]]; then
  remarks="$test_executeShellCommands_remarks $remarks"
elif [[ ${#test_executePwdCmd_remarks} -gt 0 ]]; then
  remarks="$test_executePwdCmd_remarks $remarks"
elif [[ ${#test_executeDateCmd_remarks} -gt 0 ]]; then
  remarks="$test_executeDateCmd_remarks $remarks"
elif [[ ${#test_executeCatCmd_remarks} -gt 0 ]]; then
  remarks="$test_executeCatCmd_remarks $remarks"
elif [[ ${#test_executeHeadCmd_remarks} -gt 0 ]]; then
  remarks="$test_executeHeadCmd_remarks $remarks"
elif [[ ${#test_executeTailCmd_remarks} -gt 0 ]]; then
  remarks="$test_executeTailCmd_remarks $remarks"
fi
echo "Remarks: $remarks"
