#!/bin/bash

# set exit-on-error mode
set -e
# trap the exit signal instead of error(ERR) and handle it
# $? contains exit status of the last command executed
trap 'catch $? $LINENO' EXIT

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
max_score=60
# maximum score of Part 1
part1_max_score=20
# maximum score of Part 2
part2_max_score=40
# to compute total marks scored after evaluation
total_score=0
# remarks to give as per the marks scored
remarks=""

# function to evaluate the student submitted file for Part 1 Test Cases
function evaluate_part1() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  while IFS=, read -r line; do
    # line="\"$line\""
    # echo "$line"
    file_name=$( basename "$1" .py )
    # file_path=$( dirname "$1" )
    file_path="${1%/*}"
    curr_dir_path=$( pwd )
    # update the "file_path" based on the absolute path of submitted file
    if [[ "$file_path" == "$1" ]]; then
      file_path="$curr_dir_path"
    fi
    # evaluate specific function based on the test cases
    # test the "fetchWebsiteDate()" function
    if [[ "$4" -eq 0 || "$4" -eq 1 ]]; then
      python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; \
                    print(script.fetchWebsiteData('$line')); sys.path.remove('$file_path')" >> out.txt
    else
      # web_page_data=$(python3 -c "import w6_activity2_server as script; print(script.fetchWebsiteData($line))")
      IFS=, read -a test_case <<< "$line"
      web_page_url="${test_case[0]}"
      # test the "fetchVaccineDoses()" function
      if [[ "$4" -eq 2 ]]; then
        python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; web_page = open('$web_page_url'); \
                      web_page_data = script.BeautifulSoup(web_page, 'html.parser').find('table').find('tbody').find_all('tr'); \
                      print(script.fetchVaccineDoses(web_page_data)); sys.path.remove('$file_path')" >> out.txt
      # test the "fetchAgeGroup()" function
      elif [[ "$4" -eq 3 ]]; then
        dose_num="${test_case[1]}"
        python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; web_page = open('$web_page_url'); \
                      web_page_data = script.BeautifulSoup(web_page, 'html.parser').find('table').find('tbody').find_all('tr'); \
                      print(script.fetchAgeGroup(web_page_data, '$dose_num')); sys.path.remove('$file_path')" >> out.txt
      # test the "fetchStates()" function
      elif [[ "$4" -eq 4 || "$4" -eq 5 ]]; then
        dose_num="${test_case[1]}"
        age_grp="${test_case[2]}"
        python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; web_page = open('$web_page_url'); \
                      web_page_data = script.BeautifulSoup(web_page, 'html.parser').find('table').find('tbody').find_all('tr'); \
                      print(script.fetchStates(web_page_data, '$age_grp', '$dose_num')); sys.path.remove('$file_path')" >> out.txt
      # test the "fetchDistricts()" function
      elif [[ "$4" -eq 6 ]]; then
        dose_num="${test_case[1]}"
        age_grp="${test_case[2]}"
        state_name="${test_case[3]}"
        python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; web_page = open('$web_page_url'); \
                      web_page_data = script.BeautifulSoup(web_page, 'html.parser').find('table').find('tbody').find_all('tr'); \
                      print(script.fetchDistricts(web_page_data, '$state_name', '$age_grp', '$dose_num')); \
                      sys.path.remove('$file_path')" >> out.txt
      # test the "fetchHospitalVaccineNames()" function
      elif [[ "$4" -eq 7 || "$4" -eq 8 ]]; then
        dose_num="${test_case[1]}"
        age_grp="${test_case[2]}"
        state_name="${test_case[3]}"
        district_name="${test_case[4]}"
        python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; web_page = open('$web_page_url'); \
                      web_page_data = script.BeautifulSoup(web_page, 'html.parser').find('table').find('tbody').find_all('tr'); \
                      print(script.fetchHospitalVaccineNames(web_page_data, '$district_name', '$state_name', '$age_grp', '$dose_num')); \
                      sys.path.remove('$file_path')" >> out.txt
      # test the "fetchVaccineSlots()" function
      elif [[ "$4" -eq 9 || "$4" -eq 10 ]]; then
        dose_num="${test_case[1]}"
        age_grp="${test_case[2]}"
        state_name="${test_case[3]}"
        district_name="${test_case[4]}"
        hospital_name="${test_case[5]}"
        python3 -c "import sys; sys.path.append('$file_path'); import $file_name as script; web_page = open('$web_page_url'); \
                      web_page_data = script.BeautifulSoup(web_page, 'html.parser').find('table').find('tbody').find_all('tr'); \
                      print(script.fetchVaccineSlots(web_page_data, '$hospital_name', '$district_name', '$state_name', '$age_grp', '$dose_num')); \
                      sys.path.remove('$file_path')" >> out.txt
      fi
    fi
  done < "$2"
  if [[ "$?" = 0 ]]; then
    # compare the out.txt file against the ideal_part1_output_file
    # if the contents match, increment the total_score by weightage of each function
    if cmp -s out.txt "$3"; then
      # update total score wrt the weightage associated with each test case
      if [[ "$4" -eq 0 || "$4" -eq 1 ]]; then
        total_score=$(echo "scale=3;$total_score+$fetchWebsiteData_func_weightage" | bc -l)
      elif [[ "$4" -eq 2 ]]; then
        total_score=$(echo "scale=3;$total_score+$fetchVaccineDoses_func_weightage" | bc -l)
      elif [[ "$4" -eq 3 ]]; then
        total_score=$(echo "scale=3;$total_score+$fetchAgeGroup_func_weightage" | bc -l)
      elif [[ "$4" -eq 4 || "$4" -eq 5 ]]; then
        total_score=$(echo "scale=3;$total_score+$fetchStates_func_weightage" | bc -l)
      elif [[ "$4" -eq 6 ]]; then
        total_score=$(echo "scale=3;$total_score+$fetchDistricts_func_weightage" | bc -l)
      elif [[ "$4" -eq 7 || "$4" -eq 8 ]]; then
        total_score=$(echo "scale=3;$total_score+$fetchHospitalVaccineNames_func_weightage" | bc -l)
      elif [[ "$4" -eq 9 || "$4" -eq 10 ]]; then
        total_score=$(echo "scale=3;$total_score+$fetchVaccineSlots_func_weightage" | bc -l)
      fi
    else
      if [[ "$4" -eq 0 || "$4" -eq 1 ]]; then
        test_fetchWebsiteData_func_remarks="Check the fetchWebsiteData function, the fetched data does not match with the expected output. Compare your code output with the actual web-page."
      elif [[ "$4" -eq 2 ]]; then
        test_fetchVaccineDoses_func_remarks="Check the fetchVaccineDoses function, the dictionary output format fetched from a given web-page is not as expected."
      elif [[ "$4" -eq 3 ]]; then
        test_fetchAgeGroup_func_remarks="Check the fetchAgeGroup function, the dictionary output format fetched from a given web-page is not as expected."
      elif [[ "$4" -eq 4 || "$4" -eq 5 ]]; then
        test_fetchStates_func_remarks="Check the fetchStates function, the dictionary output format fetched from a given web-page is not as expected."
      elif [[ "$4" -eq 6 ]]; then
        test_fetchDistricts_func_remarks="Check the fetchDistricts function, the dictionary output format fetched from a given web-page is not as expected."
      elif [[ "$4" -eq 7 || "$4" -eq 8 ]]; then
        test_fetchHospitalVaccineNames_func_remarks="Check the fetchHospitalVaccineNames function, the dictionary output format fetched from a given web-page is not as expected."
      elif [[ "$4" -eq 9 || "$4" -eq 10 ]]; then
        test_fetchVaccineSlots_func_remarks="Check the fetchVaccineSlots function, the dictionary output format fetched from a given web-page is not as expected."
      fi
    fi
    # delete the temporary generated out.txt file
    rm -f out.txt
  else
    rm -f out.txt
  fi
}

# function to evaluate the student submitted file for Part 2 Test Cases
function evaluate_part2() {
  # run the student submitted file ($1) against the test_file ($2)
  # and generate temporary out.txt file to compare with ideal output file ($3)
  # ($4) represents the current test case number
  file_name=$( basename "$1" .py )
  # file_path=$( dirname "$1" )
  file_path="${1%/*}"
  curr_dir_path=$( pwd )
  # update the "file_path" based on the absolute path of submitted file
  if [[ "$file_path" == "$1" ]]; then
    file_path="$curr_dir_path"
  fi
  client_file_path="utilities/test_w6_activity2_client.py"
  # evaluate specific functionality based on the test cases
  # test the "quit" ('q' or 'Q') functionality
  # create a new Terminal tab in same window and run the "Server" code
  # reference: https://stackoverflow.com/questions/24908104/how-to-get-return-code-from-a-program-in-a-new-terminal-bash-inception
  temp_dir=$(mktemp -d); temp_file=$temp_dir/fifo; mkfifo $temp_file;
  gnome-terminal --tab --title server -- bash -c 'python3 "'$1'"; echo $? > "'$temp_file'"; exec $SHELL'
  # wait for few seconds for "Server" to start
  # sleep 2
  # wait
  # run the test "Client" code which provides input commands all at once
  python3 -c "import sys; sys.path.append('$file_path'); import subprocess; \
                out = subprocess.run('python3 $client_file_path $2', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT); \
                print(out.stdout.decode('utf-8')); sys.path.remove('$file_path')" >> out.txt
  # sleep 2
  # cat out.txt
  if [[ "$?" = 0 ]]; then
    server_err_flag=$( cat $temp_file )
    if [[ $server_err_flag -eq 0 ]]; then
      # compare the out.txt file against the ideal_part2_output_file
      # if the contents match, increment the total_score by weightage of each functionality
      # start_server_flag=$( cat out.txt | grep -w "*** Start the server first! ***" | wc -l )
      # if [[ $start_server_flag -eq 1 ]]; then
      #   test_start_server_remarks="Run the 'w6_activity2_server.py' file first before running the Grader App."
      # fi
      count_server_expect_client_input=$( cat out.txt | grep -o ">>>" | wc -l )
      count_server_ack_client_input=$( cat out.txt | grep -o "<<<" | wc -l )
      ideal_count_server_expect_client_input=$( cat "$3" | grep -w ">>>" | awk -F, '{sum_count+=$1} END{print sum_count}' )
      ideal_count_server_ack_client_input=$( cat "$3" | grep -w "<<<" | awk -F, '{sum_count+=$1} END{print sum_count}' )
      # echo "$count_server_expect_client_input" "$ideal_count_server_expect_client_input"
      # echo "$count_server_ack_client_input" "$ideal_count_server_ack_client_input"
      if [[ "$count_server_expect_client_input" -eq "$ideal_count_server_expect_client_input" ]]; then
        if [[ "$count_server_ack_client_input" -eq "$ideal_count_server_ack_client_input" ]]; then
          declare -a text_match_array=( )
          line_num=0; product_count_txt_find=1; ideal_product_count_txt_find=1
          while IFS=, read -r line; do
            # echo "$line"
            IFS=, read -a test_case <<< "$line"
            ideal_count_txt_find="${test_case[0]}"
            txt_to_find="${test_case[1]}"
            count_txt_find=$( cat out.txt | grep -o "$txt_to_find" | wc -l )
            # echo "$ideal_count_txt_find" "$txt_to_find" "$count_txt_find"
            text_match_array+=( $count_txt_find )
            ideal_product_count_txt_find=$(( $ideal_product_count_txt_find * $ideal_count_txt_find ))
            if [[ $count_txt_find -ne $ideal_count_txt_find ]]; then
              if [[ "$txt_to_find" == *"Select the Dose of Vaccination"* ]]; then
                test_select_dose_remarks="Make sure the Server responds with appropriate input ('>>>') message for Dose Selection, be it coming back ('b' or 'B') from Age Group selection state or providing invalid input(s)."
              
              elif [[ "$txt_to_find" == *"See ya! Visit again :)"* ]]; then
                test_ack_quit_remarks="Make sure the Server acknowledges ('<<<') with correct message when user presses 'q' or 'Q' or the Vaccination Appointment is scheduled and close the connection."
              
              elif [[ "$txt_to_find" == *"Invalid input provided"* ]]; then
                test_ack_invalid_remarks="Server should acknowledge ('<<<') the invalid input provided for maximum of three times to Client at a given state in the work-flow and then close the connection by quitting the program."
              
              elif [[ "$txt_to_find" == *"Dose selected: 1"* ]]; then
                test_ack_dose1_remarks="Server should acknowledge ('<<<') the 1st Dose selection by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Select the Age Group"* ]]; then
                test_select_age_remarks="Make sure the Server responds with appropriate input ('>>>') message for Age Group Selection, be it coming back ('b' or 'B') from State selection or providing invalid input(s) or after the user is eligible for taking 2nd Vaccination Dose for the provided date of 1st Vaccination."
              
              elif [[ "$txt_to_find" == *"Selected Age Group: 18+"* ]]; then
                test_ack_age18_remarks="Server should acknowledge ('<<<') the 18+ Age Group selection by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Selected Age Group: 45+"* ]]; then
                test_ack_age45_remarks="Server should acknowledge ('<<<') the 45+ Age Group selection by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Select the State"* ]]; then
                test_select_state_remarks="Make sure the Server responds with appropriate input ('>>>') message for States Selection, be it coming back ('b' or 'B') from District selection or providing invalid input(s)."
              
              elif [[ ("$txt_to_find" == *"Selected State: Jammu and Kashmir"*) || ("$txt_to_find" == *"Selected State: West Bengal"*) || ("$txt_to_find" == *"Selected State: Jharkhand"*) || ("$txt_to_find" == *"Selected State: Punjab"*) || ("$txt_to_find" == *"Selected State: Meghalaya"*) ]]; then
                test_ack_state_remarks="Server should acknowledge ('<<<') the State selection by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Select the District"* ]]; then
                test_select_district_remarks="Make sure the Server responds with appropriate input ('>>>') message for Districts Selection, be it coming back ('b' or 'B') from Vaccination Center Name selection or providing invalid input(s)."
              
              elif [[ ("$txt_to_find" == *"Selected District: Howrah"*) || ("$txt_to_find" == *"Selected District: Srinagar"*) || ("$txt_to_find" == *"Selected District: Ludhiana"*) || ("$txt_to_find" == *"Selected District: West Jaintia Hills"*) || ("$txt_to_find" == *"Selected District: East Khasi Hills"*) ]]; then
                test_ack_district_remarks="Server should acknowledge ('<<<') the District selection by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Select the Vaccination Center Name"* ]]; then
                test_select_vacc_center_remarks="Make sure the Server responds with appropriate input ('>>>') message for Vaccination Center Name Selection, be it coming back ('b' or 'B') from available Vaccination Slot selection or providing invalid input(s)."
              
              elif [[ ("$txt_to_find" == *"Selected Vaccination Center: Highland Clinic"*) || ("$txt_to_find" == *"Selected Vaccination Center: Grand Meadow Hospital"*) || ("$txt_to_find" == *"Selected Vaccination Center: Well and Good Clinic"*) || ("$txt_to_find" == *"Selected Vaccination Center: GoodAce care"*) ]]; then
                test_ack_vacc_center_remarks="Server should acknowledge ('<<<') the Vaccination Center Name selection by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Select one of the available slots to schedule the Appointment"* ]]; then
                test_select_vacc_slots_remarks="Make sure the Server responds with appropriate input ('>>>') message for available Vaccination Slots Selection, be it providing invalid input(s) or selection of a appointment date having no available slots."
              
              elif [[ ("$txt_to_find" == *"Selected Vaccination Appointment Date: May 15"*) || ("$txt_to_find" == *"Selected Vaccination Appointment Date: May 20"*) || ("$txt_to_find" == *"Selected Vaccination Appointment Date: May 19"*) || ("$txt_to_find" == *"Selected Vaccination Appointment Date: May 16"*) ]]; then
                test_ack_vacc_date_remarks="Server should acknowledge ('<<<') the selected Vaccination Appointment Date by Client with correct message."
              
              elif [[ ("$txt_to_find" == *"Available Slots on the selected Date: 0"*) || ("$txt_to_find" == *"Available Slots on the selected Date: 91"*) || ("$txt_to_find" == *"Available Slots on the selected Date: 34"*) || ("$txt_to_find" == *"Available Slots on the selected Date: 129"*) ]]; then
                test_ack_avail_vacc_slots_remarks="Server should acknowledge ('<<<') the number of Vaccination Slots available on the Appointment Date selected by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Selected Appointment Date has no available slots"* ]]; then
                test_ack_no_avail_vacc_slots_remarks="Server should acknowledge ('<<<') that there are no available slots if the selected Appointment Date has '0' available Vaccination Slots."
              
              elif [[ "$txt_to_find" == *"<<< Your appointment is scheduled."* ]]; then
                test_ack_appoint_sched_remarks="Server should acknowledge ('<<<') that the Vaccination Appointment is scheduled if the selected Appointment Date has '> 0' available Vaccination Slots."
              
              elif [[ "$txt_to_find" == *"Dose selected: 2"* ]]; then
                test_ack_dose2_remarks="Server should acknowledge ('<<<') the 2nd Dose selection by Client with correct message."
              
              elif [[ "$txt_to_find" == *"Provide the date of First Vaccination Dose (DD/MM/YYYY)"* ]]; then
                test_select_date_first_vacc_dose_remarks="Make sure the Server responds with appropriate input ('>>>') message for providing date of 1st Vaccination Dose."
              
              elif [[ ("$txt_to_find" == *"Invalid Date provided of First Vaccination Dose: 12/5/2100"*) || ("$txt_to_find" == *"Invalid Date provided of First Vaccination Dose: 31/12/2100"*) || ("$txt_to_find" == *"Invalid Date provided of First Vaccination Dose: 16/10/2100"*) ]]; then
                test_ack_invalid_date_first_vacc_dose_remarks="Server should acknowledge ('<<<') the selected date of 1st Vaccination Dose with correct message if its invalid."
              
              elif [[ ("$txt_to_find" == *"Date of First Vaccination Dose provided: 20/5/2021"*) || ("$txt_to_find" == *"Number of weeks from today"*) || ("$txt_to_find" == *"Date of First Vaccination Dose provided: 23/12/2020"*) || ("$txt_to_find" == *"Date of First Vaccination Dose provided: 15/4/2021"*) ]]; then
                test_ack_valid_date_first_vacc_dose_remarks="Server should acknowledge ('<<<') the selected date of 1st Vaccination Dose with correct message if its valid and also state the difference in number of weeks from today and the provided date by the user."
              
              elif [[ ("$txt_to_find" == *"You are not eligible right now for 2nd Vaccination Dose! Try after"*) ]]; then
                test_ack_valid_date_first_vacc_dose_not_eligible_remarks="Server should acknowledge ('<<<') the selected date of 1st Vaccination Dose with correct message if it falls within 4 weeks from today, as the user is not eligible to take 2nd Vaccination Dose and should try after certain number of weeks."
              
              elif [[ ("$txt_to_find" == *"You have been late in scheduling your 2nd Vaccination Dose by"*) ]]; then
                test_ack_valid_date_first_vacc_dose_eligible_late_remarks="Server should acknowledge ('<<<') the selected date of 1st Vaccination Dose with correct message if its beyond the limit of 8 weeks from today, as the user is eligible to take 2nd Vaccination Dose but is late by certain number of weeks."
              
              elif [[ ("$txt_to_find" == *"You are eligible for 2nd Vaccination Dose and are in the right time-frame to take it."*) ]]; then
                test_ack_valid_date_first_vacc_dose_eligible_ontime_remarks="Server should acknowledge ('<<<') the selected date of 1st Vaccination Dose with correct message if its within the limit of 4 to 8 weeks from today, as the user is eligible to take 2nd Vaccination Dose and is in the right time-frame."
              
              fi
            fi
            line_num+=1
          done < "$3"
          # echo "Array: ${text_match_array[@]}"
          product_count_txt_find=$(( $( IFS="*"; echo "${text_match_array[*]}" ) ))
          # echo $product_count_txt_find $ideal_product_count_txt_find
          if [[ $product_count_txt_find -eq $ideal_product_count_txt_find ]]; then
            total_score=$(echo "scale=3;$total_score+$part2_test_case_weightage" | bc -l)
          fi
        else
          test_ack_input_remarks="Make sure the Server aknowledges ('<<<') with correct message for the input selected by Client at all states of work-flow, such as quitting ('q' or 'Q')."
        fi
      else
        test_select_input_remarks="Make sure the Server responds with appropriate input ('>>>') message for selection of inputs at all states of work-flow, such as going back ('b' or 'B') to previous state or invalid inputs, etc."
      fi
      # delete the temporary generated out.txt file
      rm -f out.txt
    else
      test_server_run_remarks="An exception occurred while starting or running the Server code! Debug it."
      rm -f out.txt
    fi
  else
    rm -f out.txt
  fi
  rm -rf $temp_dir
}

# take the student submitted file name from input arguments
submission_file=$1

# find Part 1 Test TXT Files and their count
cmd_find_part1_test_files=$(ls utilities/a1_part1_test_case**.txt -v)
part1_test_files_list=($cmd_find_part1_test_files)
# print file names of all part1 test txt files
# echo "Part 1 Test TXT file list names: ${part1_test_files_list[@]}"
# print number of all part1 test txt files
no_of_part1_test_cases="${#part1_test_files_list[@]}"

# find Part 2 Test TXT Files and their count
cmd_find_part2_test_files=$(ls utilities/a1_part2_test_case**.txt -v)
part2_test_files_list=($cmd_find_part2_test_files)
# print file names of all part2 test txt files
# echo "Part 2 Test TXT file list names: ${part2_test_files_list[@]}"
# print number of all part2 test txt files
no_of_part2_test_cases="${#part2_test_files_list[@]}"

no_of_test_cases=$(( $no_of_part1_test_cases + $no_of_part2_test_cases ))
echo "Number of Test TXT files: $no_of_test_cases"

# compute the weightage of part1 test cases
# part1_test_case_weightage=$(echo "scale=3;$part1_max_score/$no_of_part1_test_cases" | bc -l)
# echo $part1_test_case_weightage

# compute the weightage of "fetchWebsiteData" function with 10%
fetchWebsiteData_func_weightage=$(echo "scale=3;$part1_max_score*0.05" | bc -l)
# compute the weightage of "fetchVaccineDoses" function with 10%
fetchVaccineDoses_func_weightage=$(echo "scale=3;$part1_max_score*0.1" | bc -l)
# compute the weightage of "fetchAgeGroup" function with 10%
fetchAgeGroup_func_weightage=$(echo "scale=3;$part1_max_score*0.1" | bc -l)
# compute the weightage of "fetchStates" function with 15%
fetchStates_func_weightage=$(echo "scale=3;$part1_max_score*0.075" | bc -l)
# compute the weightage of "fetchDistricts" function with 15%
fetchDistricts_func_weightage=$(echo "scale=3;$part1_max_score*0.15" | bc -l)
# compute the weightage of "fetchHospitalVaccineNames" function with 20%
fetchHospitalVaccineNames_func_weightage=$(echo "scale=3;$part1_max_score*0.1" | bc -l)
# compute the weightage of "fetchVaccineSlots" function with 20%
fetchVaccineSlots_func_weightage=$(echo "scale=3;$part1_max_score*0.1" | bc -l)

# compute the weightage of part2 test cases
part2_test_case_weightage=$(echo "scale=3;$part2_max_score/$no_of_part2_test_cases" | bc -l)
# echo $part2_test_case_weightage

# find Ideal Part1 Output TXT Files for all functions
cmd_find_ideal_part1_output_files=$(ls utilities/ideal_a1_part1_test_case**.txt -v)
ideal_part1_output_files_list=($cmd_find_ideal_part1_output_files)

# find Ideal Part2 Output TXT Files for all functions
cmd_find_ideal_part2_output_files=$(ls utilities/ideal_a1_part2_test_case**.txt -v)
ideal_part2_output_files_list=($cmd_find_ideal_part2_output_files)

# start the evaluation of Part1
test_case_num=0
while [ $test_case_num -lt $no_of_part1_test_cases ]; do
  echo "===================================="
  echo "Evaluating for Test case: $((test_case_num + 1))"
  import_word_count=$( cat "$1" | grep -w "import" | wc -l )
  import_socket_flag=$( cat "$1" | grep "import socket$" | wc -l )
  import_bs4_flag=$( cat "$1" | grep "from bs4 import BeautifulSoup$" | wc -l )
  import_requests_flag=$( cat "$1" | grep "import requests$" | wc -l )
  import_datetime_flag=$( cat "$1" | grep "import datetime$" | wc -l )
  if [[ "$import_word_count" -eq 4 && "$import_socket_flag" -eq 1 && "$import_bs4_flag" -eq 1 &&
        "$import_requests_flag" -eq 1 && "$import_datetime_flag" -eq 1 ]]; then
    # get the part1_test_file name
    part1_test_file="${part1_test_files_list[$test_case_num]}"
    # get the ideal_part1_output_file name
    ideal_part1_output_file="${ideal_part1_output_files_list[$test_case_num]}"
    # evaluate the student submitted file against the test_file
    # and generate temporary out.txt file to compare with ideal_part1_output_file
    evaluate_part1 "$submission_file" "$part1_test_file" "$ideal_part1_output_file" "$test_case_num"
  fi
  echo "Score up till Test case number $(($test_case_num + 1)) = $total_score"
  echo "===================================="
  # increment test_case_num variable
  test_case_num=$(($test_case_num + 1))
done

# start the evaluation of Part2
part2_test_case_num=$(($test_case_num - $no_of_part1_test_cases))
while [ $part2_test_case_num -lt $no_of_part2_test_cases ]; do
  echo "===================================="
  echo "Evaluating for Test case: $((test_case_num + 1))"
  # get the part2_test_file name
  part2_test_file="${part2_test_files_list[$part2_test_case_num]}"
  # get the ideal_part2_output_file name
  ideal_part2_output_file="${ideal_part2_output_files_list[$part2_test_case_num]}"
  # evaluate the student submitted file against the test_file
  # and generate temporary out.txt file to compare with ideal_part2_output_file
  evaluate_part2 "$submission_file" "$part2_test_file" "$ideal_part2_output_file" "$part2_test_case_num"
  echo "Score up till Test case number $(($test_case_num + 1)) = $total_score"
  echo "===================================="
  # increment test_case_num, part2_test_case_num variables
  test_case_num=$(($test_case_num + 1))
  part2_test_case_num=$(($part2_test_case_num + 1))
done


# round off the total_score to the nearest integer
total_score=$(echo "($total_score+0.5)/1" | bc)
echo "Marks scored: $total_score"

# provide remarks as per the total marks scored
if [[ "$total_score" -eq $max_score && "$import_word_count" -eq 4 && "$import_socket_flag" -eq 1 && "$import_bs4_flag" -eq 1 &&
        "$import_requests_flag" -eq 1 && "$import_datetime_flag" -eq 1 ]]; then
  echo "SUCCESS, Your code passed all the test cases."
  remarks="Congrats! You have successfully completed the assignment. Keep it up!"
elif [[ "$total_score" -lt $max_score && "$import_word_count" -eq 4 && "$import_socket_flag" -eq 1 && "$import_bs4_flag" -eq 1 &&
        "$import_requests_flag" -eq 1 && "$import_datetime_flag" -eq 1 ]]; then
  echo "FAIL, Your code did not pass one or more test cases."
  remarks="Your code did not pass all of the test cases. You need not worry, keep trying until you get all of them passed!"
else
  echo "FAIL, Your code consists of an extra import statement or is importing other module(s) apart from socket, bs4, requests and datetime."
  remarks="Your code was not evaluated as it consists of an extra import statement or is importing other module(s) apart from socket, bs4, requests and datetime!"
fi

# concatenate the Part1 remarks
if [[ ${#test_fetchWebsiteData_func_remarks} -gt 0 ]]; then
  test_part1_remarks="$test_fetchWebsiteData_func_remarks"
elif [[ ${#test_fetchVaccineDoses_func_remarks} -gt 0 ]]; then
  test_part1_remarks="$test_fetchVaccineDoses_func_remarks"
elif [[ ${#test_fetchAgeGroup_func_remarks} -gt 0 ]]; then
  test_part1_remarks="$test_fetchAgeGroup_func_remarks"
elif [[ ${#test_fetchStates_func_remarks} -gt 0 ]]; then
  test_part1_remarks="$test_fetchStates_func_remarks"
elif [[ ${#test_fetchDistricts_func_remarks} -gt 0 ]]; then
  test_part1_remarks="$test_fetchDistricts_func_remarks"
elif [[ ${#test_fetchHospitalVaccineNames_func_remarks} -gt 0 ]]; then
  test_part1_remarks="$test_fetchHospitalVaccineNames_func_remarks"
elif [[ ${#test_fetchVaccineSlots_func_remarks} -gt 0 ]]; then
  test_part1_remarks="$test_fetchVaccineSlots_func_remarks"
fi

if [[ ${#test_part1_remarks} -gt 0 ]]; then
  remarks="$test_part1_remarks $remarks"
fi

# concatenate the Part2 (select and ack input) remarks
if [[ ${#test_server_run_remarks} -gt 0 ]]; then
  test_part2_1_remarks="$test_server_run_remarks"
elif [[ ${#test_select_input_remarks} -gt 0 ]]; then
  test_part2_1_remarks="$test_select_input_remarks"
elif [[ ${#test_ack_input_remarks} -gt 0 ]]; then
  test_part2_1_remarks="$test_ack_input_remarks"

# concatenate the Part 2 work-flow remarks
elif [[ ${#test_select_dose_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_select_dose_remarks"
elif [[ ${#test_ack_quit_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_quit_remarks"
elif [[ ${#test_ack_invalid_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_invalid_remarks"
elif [[ ${#test_ack_dose1_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_dose1_remarks"
elif [[ ${#test_select_age_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_select_age_remarks"
elif [[ ${#test_ack_age18_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_age18_remarks"
elif [[ ${#test_ack_age45_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_age45_remarks"
elif [[ ${#test_select_state_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_select_state_remarks"
elif [[ ${#test_ack_state_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_state_remarks"
elif [[ ${#test_select_district_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_select_district_remarks"
elif [[ ${#test_ack_district_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_district_remarks"
elif [[ ${#test_select_vacc_center_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_select_vacc_center_remarks"
elif [[ ${#test_ack_vacc_center_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_vacc_center_remarks"
elif [[ ${#test_select_vacc_slots_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_select_vacc_slots_remarks"
elif [[ ${#test_ack_vacc_date_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_vacc_date_remarks"
elif [[ ${#test_ack_avail_vacc_slots_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_avail_vacc_slots_remarks"
elif [[ ${#test_ack_no_avail_vacc_slots_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_no_avail_vacc_slots_remarks"
elif [[ ${#test_ack_appoint_sched_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_appoint_sched_remarks"
elif [[ ${#test_ack_dose2_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_dose2_remarks"
elif [[ ${#test_select_date_first_vacc_dose_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_select_date_first_vacc_dose_remarks"
elif [[ ${#test_ack_invalid_date_first_vacc_dose_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_invalid_date_first_vacc_dose_remarks"
elif [[ ${#test_ack_valid_date_first_vacc_dose_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_valid_date_first_vacc_dose_remarks"
elif [[ ${#test_ack_valid_date_first_vacc_dose_not_eligible_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_valid_date_first_vacc_dose_not_eligible_remarks"
elif [[ ${#test_ack_valid_date_first_vacc_dose_eligible_late_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_valid_date_first_vacc_dose_eligible_late_remarks"
elif [[ ${#test_ack_valid_date_first_vacc_dose_eligible_ontime_remarks} -gt 0 ]]; then
  test_part2_2_remarks="$test_ack_valid_date_first_vacc_dose_eligible_ontime_remarks"
fi

if [[ ${#test_part2_1_remarks} -gt 0 ]]; then
  remarks="$test_part2_1_remarks $remarks"
fi

if [[ ${#test_part2_2_remarks} -gt 0 ]]; then
  remarks="$test_part2_2_remarks $remarks"
fi

echo "Remarks: $remarks"
