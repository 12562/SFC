
# No other modules apart from 'socket', 'BeautifulSoup', 'requests' and 'datetime'
# need to be imported as they aren't required to solve the assignment

# Import required module/s
import socket
from bs4 import BeautifulSoup
import requests
import datetime


# Define constants for IP and Port address of Server
# NOTE: DO NOT modify the values of these two constants
HOST = '127.0.0.1'
PORT = 24680


def fetchWebsiteData(url_website):
	"""Fetches rows of tabular data from given URL of a website with data excluding table headers.

	Parameters
	----------
	url_website : str
		URL of a website

	Returns
	-------
	bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers
	"""
	
	web_page_data = ''

	##############	ADD YOUR CODE HERE	##############
	req = requests.get(url_website)
	soup = BeautifulSoup(req.text, 'html.parser')
	web_page_data = soup.select('tr[class^="row"]')
	##################################################

	return web_page_data


def fetchVaccineDoses(web_page_data):
	"""Fetch the Vaccine Doses available from the Web-page data and provide Options to select the respective Dose.

	Parameters
	----------
	web_page_data : bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers

	Returns
	-------
	dict
		Dictionary with the Doses available and Options to select, with Key as 'Option' and Value as 'Command'
	
	Example
	-------
	>>> url_website = "https://www.mooc.e-yantra.org/task-spec/fetch-mock-covidpage"
	>>> web_page_data = fetchWebsiteData(url_website)
	>>> print(fetchVaccineDoses(web_page_data))
	{'1': 'Dose 1', '2': 'Dose 2'}
	"""

	vaccine_doses_dict = {}

	##############	ADD YOUR CODE HERE	##############
	dose_lst = []
	dose_class = 'dose_num'
	for row in web_page_data:
		dose_lst.append(row.find('td', {'class': dose_class}).text)
		#dose_lst.append(row.text.split('\n')[12])
	unique_doses = sorted(set(dose_lst))
	vaccine_doses_dict = {dose_num:'Dose ' + dose_num for dose_num in unique_doses}
	##################################################

	return vaccine_doses_dict


def fetchAgeGroup(web_page_data, dose):
	"""Fetch the Age Groups for whom Vaccination is available from the Web-page data for a given Dose
	and provide Options to select the respective Age Group.

	Parameters
	----------
	web_page_data : bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers
	dose : str
		Dose available for Vaccination and its availability for the Age Groups

	Returns
	-------
	dict
		Dictionary with the Age Groups (for whom Vaccination is available for a given Dose) and Options to select,
		with Key as 'Option' and Value as 'Command'
	
	Example
	-------
	>>> url_website = "https://www.mooc.e-yantra.org/task-spec/fetch-mock-covidpage"
	>>> web_page_data = fetchWebsiteData(url_website)
	>>> print(fetchAgeGroup(web_page_data, '1'))
	{'1': '18+', '2': '45+'}
	>>> print(fetchAgeGroup(web_page_data, '2'))
	{'1': '18+', '2': '45+'}
	"""

	age_group_dict = {}

	##############	ADD YOUR CODE HERE	##############
	agegroup = []
	dose_class = 'dose_num'
	age_class = 'age'
	for row in web_page_data:
		if (row.find('td', {'class': dose_class}).text == dose):
			agegroup.append(row.find('td', {'class': age_class}).text)
	
	sorted_agegroup = sorted(set(agegroup))
	age_group_dict = {str(i+1): sorted_agegroup[i] for i in range(len(sorted_agegroup))}
	##################################################

	return age_group_dict


def fetchStates(web_page_data, age_group, dose):
	"""Fetch the States where Vaccination is available from the Web-page data for a given Dose and Age Group
	and provide Options to select the respective State.

	Parameters
	----------
	web_page_data : bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers
	age_group : str
		Age Group available for Vaccination and its availability in the States
	dose : str
		Dose available for Vaccination and its availability for the Age Groups

	Returns
	-------
	dict
		Dictionary with the States (where the Vaccination is available for a given Dose, Age Group) and Options to select,
		with Key as 'Option' and Value as 'Command'
	
	Example
	-------
	>>> url_website = "https://www.mooc.e-yantra.org/task-spec/fetch-mock-covidpage"
	>>> web_page_data = fetchWebsiteData(url_website)
	>>> print(fetchStates(web_page_data, '18+', '1'))
	{
		'1': 'Andhra Pradesh', '2': 'Arunachal Pradesh', '3': 'Bihar', '4': 'Chandigarh', '5': 'Delhi', '6': 'Goa',
		'7': 'Gujarat', '8': 'Harayana', '9': 'Himachal Pradesh', '10': 'Jammu and Kashmir', '11': 'Kerala', '12': 'Telangana'
	}
	"""

	states_dict = {}

	##############	ADD YOUR CODE HERE	##############
	dose_class = 'dose_num'
	age_class = 'age'
	state_class = 'state_name'
	states = []
	for row in web_page_data:
		if ( row.find('td', {'class': dose_class}).text == dose and row.find('td', {'class': age_class}).text == age_group):
			states.append(row.find('td', {'class': state_class}).text)
	sorted_states = sorted(set(states))
	states_dict = {str(i+1): sorted_states[i] for i in range(len(sorted_states))}
	##################################################

	return states_dict


def fetchDistricts(web_page_data, state, age_group, dose):
	"""Fetch the District where Vaccination is available from the Web-page data for a given State, Dose and Age Group
	and provide Options to select the respective District.

	Parameters
	----------
	web_page_data : bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers
	state : str
		State where Vaccination is available for a given Dose and Age Group
	age_group : str
		Age Group available for Vaccination and its availability in the States
	dose : str
		Dose available for Vaccination and its availability for the Age Groups

	Returns
	-------
	dict
		Dictionary with the Districts (where the Vaccination is available for a given State, Dose, Age Group) and Options to select,
		with Key as 'Option' and Value as 'Command'
	
	Example
	-------
	>>> url_website = "https://www.mooc.e-yantra.org/task-spec/fetch-mock-covidpage"
	>>> web_page_data = fetchWebsiteData(url_website)
	>>> print(fetchDistricts(web_page_data, 'Ladakh', '18+', '2'))
	{
		'1': 'Kargil', '2': 'Leh'
	}
	"""

	districts_dict = {}

	##############	ADD YOUR CODE HERE	##############
	dose_class = 'dose_num'
	age_class = 'age'
	state_class = 'state_name'
	district_class = 'district_name'
	districts = []
	for row in web_page_data:
		if ( row.find('td', {'class': dose_class}).text == dose and row.find('td', {'class': age_class}).text == age_group and row.find('td', {'class': state_class}).text == state):
			districts.append(row.find('td', {'class': district_class}).text)
	sorted_districts = sorted(set(districts))
	districts_dict = {str(i+1): sorted_districts[i] for i in range(len(sorted_districts))}
	##################################################

	return districts_dict


def fetchHospitalVaccineNames(web_page_data, district, state, age_group, dose):
	"""Fetch the Hospital and the Vaccine Names from the Web-page data available for a given District, State, Dose and Age Group
	and provide Options to select the respective Hospital and Vaccine Name.

	Parameters
	----------
	web_page_data : bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers
	district : str
		District where Vaccination is available for a given State, Dose and Age Group
	state : str
		State where Vaccination is available for a given Dose and Age Group
	age_group : str
		Age Group available for Vaccination and its availability in the States
	dose : str
		Dose available for Vaccination and its availability for the Age Groups

	Returns
	-------
	dict
		Dictionary with the Hosptial and Vaccine Names (where the Vaccination is available for a given District, State, Dose, Age Group)
		and Options to select, with Key as 'Option' and Value as another dictionary having Key as 'Hospital Name' and Value as 'Vaccine Name'
	
	Example
	-------
	>>> url_website = "https://www.mooc.e-yantra.org/task-spec/fetch-mock-covidpage"
	>>> web_page_data = fetchWebsiteData(url_website)
	>>> print(fetchHospitalVaccineNames(web_page_data, 'Kargil', 'Ladakh', '18+', '2'))
	{
		'1': {
				'MedStar Hospital Center': 'Covaxin'
			}
	}
	>>> print(fetchHospitalVaccineNames(web_page_data, 'South Goa', 'Goa', '45+', '2'))
	{
		'1': {
				'Eden Clinic': 'Covishield'
			}
	}
	"""
	
	hospital_vaccine_names_dict = {}

	##############	ADD YOUR CODE HERE	##############
	dose_class = 'dose_num'
	age_class = 'age'
	state_class = 'state_name'
	district_class = 'district_name'
	hospital_class = 'hospital_name'
	vaccine_class = 'vaccine_name'
        #class_dict = {'dose_num': dose, 'age': age_group, 'state_name': state, 'district_name': district} 
	hospitals_vaccine = []
	for row in web_page_data:
		#row_select = True
		#for class_name in class_dict.keys():
		#	if ( row.find('td', {'class': class_name}).text != class_dict[class_name] ):
		#		row_select = False
		#if ( row_select ):
		if ( row.find('td', {'class': dose_class}).text == dose and row.find('td', {'class': age_class}).text == age_group and row.find('td', {'class': state_class}).text == state and row.find('td', {'class': district_class}).text == district):
			hospitals_vaccine.append(row.find('td', {'class': hospital_class}).text + ',' + row.find('td', {'class': vaccine_class}).text)
	sorted_hospitals_vaccine = sorted(set(hospitals_vaccine))
	hospital_vaccine_names_dict = {str(i+1): {sorted_hospitals_vaccine[i].split(',')[0]: sorted_hospitals_vaccine[i].split(',')[1]} for i in range(len(sorted_hospitals_vaccine))}
	##################################################

	return hospital_vaccine_names_dict


def fetchVaccineSlots(web_page_data, hospital_name, district, state, age_group, dose):
	"""Fetch the Dates and Slots available on those dates from the Web-page data available for a given Hospital Name, District, State, Dose and Age Group
	and provide Options to select the respective Date and available Slots.

	Parameters
	----------
	web_page_data : bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers
	hospital_name : str
		Name of Hospital where Vaccination is available for given District, State, Dose and Age Group
	district : str
		District where Vaccination is available for a given State, Dose and Age Group
	state : str
		State where Vaccination is available for a given Dose and Age Group
	age_group : str
		Age Group available for Vaccination and its availability in the States
	dose : str
		Dose available for Vaccination and its availability for the Age Groups

	Returns
	-------
	dict
		Dictionary with the Dates and Slots available on those dates (where the Vaccination is available for a given Hospital Name,
		District, State, Dose, Age Group) and Options to select, with Key as 'Option' and Value as another dictionary having
		Key as 'Date' and Value as 'Available Slots'
	
	Example
	-------
	>>> url_website = "https://www.mooc.e-yantra.org/task-spec/fetch-mock-covidpage"
	>>> web_page_data = fetchWebsiteData(url_website)
	>>> print(fetchVaccineSlots(web_page_data, 'MedStar Hospital Center', 'Kargil', 'Ladakh', '18+', '2'))
	{
		'1': {'May 15': '0'}, '2': {'May 16': '81'}, '3': {'May 17': '109'}, '4': {'May 18': '78'},
		'5': {'May 19': '89'}, '6': {'May 20': '57'}, '7': {'May 21': '77'}
	}
	>>> print(fetchVaccineSlots(web_page_data, 'Eden Clinic', 'South Goa', 'Goa', '45+', '2'))
	{
		'1': {'May 15': '0'}, '2': {'May 16': '137'}, '3': {'May 17': '50'}, '4': {'May 18': '78'},
		'5': {'May 19': '145'}, '6': {'May 20': '64'}, '7': {'May 21': '57'}
	}
	"""

	vaccine_slots = {}

	##############	ADD YOUR CODE HERE	##############
	dose_class = 'dose_num'
	age_class = 'age'
	state_class = 'state_name'
	district_class = 'district_name'
	hospital_class = 'hospital_name'
	dates = ['May 15', 'May 16', 'May 17', 'May 18', 'May 19', 'May 20', 'May 21']
	dates_class = ['may_15', 'may_16', 'may_17', 'may_18', 'may_19', 'may_20', 'may_21']
	for row in web_page_data:
		if ( row.find('td', {'class': dose_class}).text == dose and row.find('td', {'class': age_class}).text == age_group and row.find('td', {'class': state_class}).text == state and row.find('td', {'class': district_class}).text == district and row.find('td', {'class': hospital_class}).text == hospital_name):
			for i in range(len(dates)):
				vaccine_slots[str(i + 1)] = {dates[i]: row.find('td', {'class': dates_class[i]}).text}
				i += 1
	##################################################

	return vaccine_slots


def openConnection():
	"""Opens a socket connection on the HOST with the PORT address.

	Returns
	-------
	socket
		Object of socket class for the Client connected to Server and communicate further with it
	tuple
		IP and Port address of the Client connected to Server
	"""

	client_socket = None
	client_addr = None

	##############	ADD YOUR CODE HERE	##############
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	s.bind((HOST, PORT))
	s.listen(1)
	client_socket, client_addr = s.accept()
	##################################################
	
	return client_socket, client_addr


def startCommunication(client_conn, client_addr, web_page_data):
	"""Starts the communication channel with the connected Client for scheduling an Appointment for Vaccination.

	Parameters
	----------
	client_conn : socket
		Object of socket class for the Client connected to Server and communicate further with it
	client_addr : tuple
		IP and Port address of the Client connected to Server
	web_page_data : bs4.element.ResultSet
		All rows of Tabular data fetched from a website excluding the table headers
	"""

	##############	ADD YOUR CODE HERE	##############
	print('Client is connected at: ', client_addr)
		#data = client_conn.recv(1024)
		#if not data: break
	messages = ['the Dose of Vaccination', 'the Age Group', 'the State', 'the District', 'the Vaccination Center Name', 'one of the available slots to schedule the Appointment']
	fnx_names = ['fetchVaccineDoses', 'fetchAgeGroup', 'fetchStates', 'fetchDistricts', 'fetchHospitalVaccineNames', 'fetchVaccineSlots']
	arg_names = ['web_page_data', 'vaccination_slot', 'hospital_name', 'district', 'state', 'age_group', 'dose']
	imessages = ['Dose selected: ', 'Selected Age Group: ', 'Selected State: ', 'Selected District: ', 'Selected Vaccination Center: ', 'Selected Vaccination Appointment Date: ']
	server_msgs = ['Dose selected: ', 'Age Group selected: ', 'State selected: ', 'District selected: ', 'Hospital selected: ', 'Vaccination Date selected: ']
	fnx_arg_lst = [([arg_names[0]] + arg_names[i+2:]) for i in range(len(fnx_names))] 
	dict_usr_inp = {}
	dict_usr_inp['web_page_data'] = web_page_data
	
	starting_message = get_starting_message()
	send_data(starting_message, client_conn)
	ctr = 0
	globals()['invalidinput'] = 0
	while(ctr < 6):
		fetchfnx = get_fetch_fnx(fnx_names, ctr)
		fetchfnxargs = get_fetch_fnx_args(dict_usr_inp, fnx_arg_lst, fnx_names, ctr)
		fetchfnxoutputdict = fetchfnx(*fetchfnxargs)
		question_message = get_question_message(messages, fetchfnxoutputdict, ctr)
		send_data(question_message, client_conn)
		option = recv_data(client_conn)
		#print("Option is : " , option)
		if (option == ''):
			option = 'q'
		not_req0, not_req1, not_req2, not_req3, ctr = handleinput(fetchfnxoutputdict, option, False, client_conn, ctr, globals()['validoptionfn'], [fetchfnxoutputdict, ctr, dict_usr_inp, arg_names, fnx_names, imessages, server_msgs])
		ctr += 1		
		if ( ctr < 0 ):
			ctr = 0
	stopCommunication(client_conn)
				
			

	#data = '============================\n# Welcome to CoWIN ChatBot #\n============================\n\nSchedule an Appointment for Vaccination:\n\n>>> Select the Dose of Vaccination:\n' + str(fetchVaccineDoses(web_page_data)) + '\n'
	#client_conn.send(data.encode('utf-8'))
	#dose = client_conn.recv(1024).decode('utf-8')
	#data = '\n<<< Dose selected: ' + dose + '\n\n>>> Select the Age Group:\n' + str(fetchAgeGroup(web_page_data, dose)) + '\n'
	#client_conn.send(data.encode('utf-8'))
	#age_group_option = client_conn.recv(1024).decode('utf-8')
	#age_group = fetchAgeGroup(web_page_data, dose)[age_group_option] 
	#data = '\n<<< Selected Age Group: ' + age_group + '\n\n>>> Select the State:\n' + str(fetchStates(web_page_data, age_group, dose)) + '\n'
	#client_conn.send(data.encode('utf-8'))
	#state_option = client_conn.recv(1024).decode('utf-8')
	#state = fetchStates(web_page_data, age_group, dose)[state_option]
	#data = '\n<<< Selected State: ' + state + '\n\n>>> Select the District:\n' + str(fetchDistricts(web_page_data, state, age_group, dose)) + '\n'
	#client_conn.send(data.encode('utf-8'))
	#district_option = client_conn.recv(1024).decode('utf-8')
	#district = fetchDistricts(web_page_data, state, age_group, dose)[district_option]
	#data = '\n<<< Selected District: ' + district + '\n\n>>> Select the Vaccination Center Name:\n' + str(fetchHospitalVaccineNames(web_page_data, district, state, age_group, dose)) + '\n'
	#client_conn.send(data.encode('utf-8'))
	#hospital_name_option = client_conn.recv(1024).decode('utf-8')
	#hospital_name = list(fetchHospitalVaccineNames(web_page_data, district, state, age_group, dose)[hospital_name_option].keys())[0]
	#data = '\n<<< Selected Vaccination Center: ' + hospital_name + '\n\n>>> Select one of the available slots to schedule the Appointment:\n' + str(fetchVaccineSlots(web_page_data, hospital_name, district, state, age_group, dose)) + '\n'
	#client_conn.send(data.encode('utf-8'))
	#vaccination_slot_option = client_conn.recv(1024).decode('utf-8')
	#vaccination_slot_date = list(fetchVaccineSlots(web_page_data, hospital_name, district, state, age_group, dose)[vaccination_slot_option].keys())[0]
	#vaccination_slots = list(fetchVaccineSlots(web_page_data, hospital_name, district, state, age_group, dose)[vaccination_slot_option].values())[0]
	#data = '\n<<< Selected Vaccination Appointment Date: ' + vaccination_slot_date + '\n<<< Available Slots on the selected Date: ' + vaccination_slots + '\n<<< Your appointment is scheduled. Make sure to carry ID Proof while you visit\n<<< See ya! Visit again :)'
	#client_conn.send(data.encode('utf-8'))
	#stopCommunication(client_conn)
	#while True:
	

	##################################################


def stopCommunication(client_conn):
	"""Stops or Closes the communication channel of the Client with a message.

	Parameters
	----------
	client_conn : socket
		Object of socket class for the Client connected to Server and communicate further with it
	"""

	##############	ADD YOUR CODE HERE	##############
	send_data('<<< See ya! Visit again :)', client_conn)
	client_conn.close()

	##################################################


################# ADD UTILITY FUNCTIONS HERE #################
## You can define any utility functions for your code.      ##
## Please add proper comments to ensure that your code is   ##
## readable and easy to understand.                         ##
##############################################################
def send_data(message, client_conn):
	client_conn.send(message.encode('utf-8'))
	return

def recv_data(client_conn):
	data_rcvd = client_conn.recv(1024).decode('utf-8')
	return data_rcvd

def get_starting_message():
	return '============================\n# Welcome to CoWIN ChatBot #\n============================\n\nSchedule an Appointment for Vaccination:'

def get_fetch_fnx(fnx_names, ctr):
	return globals()[fnx_names[ctr]]

def get_fetch_fnx_args(dict_usr_inp, fnx_arg_lst, fnx_names, ctr):
	return [dict_usr_inp[arg] for arg in fnx_arg_lst[len(fnx_names) - ctr - 1]] 

def inputisvalidoption(fetchfnxoutputdict, option):
	lst = list((fetchfnxoutputdict).keys()) + ['b', 'B', 'q', 'Q']
	return option in lst
#list(((globals()[fnx_names[ctr]])(*[dict_usr_inp[arg] for arg in fnx_arg_lst[len(fnx_names) - ctr - 1]])).keys())[0]

def get_question_message(messages, fetchfnxoutputdict, ctr):
	return '\n>>> Select ' + messages[ctr] + ':\n' + str(fetchfnxoutputdict) + '\n'

def get_info_message(imessages, dict_usr_inp, arg_names, fnx_names, ctr):
	return '\n<<< ' + imessages[ctr] + (dict_usr_inp[arg_names[len(fnx_names) - ctr]])

def ask_for_first_vaccination_dose_date(client_conn):
	message = '\n>>> Provide the date of First Vaccination Dose (DD/MM/YYYY), for e.g. 12/5/2021'
	send_data(message, client_conn)
	return

def handle_invalid_date(client_conn, date):
	message = '\n<<< Invalid Date provided of First Vaccination Dose: ' + '/'.join(date) + '\n'
	send_data(message, client_conn)

def handle_second_dose(client_conn, ctr):
	x = False
	while (True):
		ask_for_first_vaccination_dose_date(client_conn)
		option = recv_data(client_conn)
		valid_option, valid_date, date, weeknum_diff, ctr = handleinput({}, option, True, client_conn, ctr, globals()['validdatefn'], [ctr])
		if (valid_option):
			return x, ctr
		if ( valid_date ):
			break
	
	message = '\n<<< Date of First Vaccination Dose provided: ' + '/'.join(date) + '\n<<< Number of weeks from today: ' + str(weeknum_diff)
	if ( weeknum_diff > 8 ):
		message += '\n<<< You have been late in scheduling your 2nd Vaccination Dose by ' + str( weeknum_diff - 8 ) + ' weeks.'
	elif ( weeknum_diff <= 8  and weeknum_diff >= 4 ):
		message += '\n<<< You are eligible for 2nd Vaccination Dose and are in the right time-frame to take it.'
	else:
		message += '\n<<< You are not eligible right now for 2nd Vaccination Dose! Try after ' + str(4 - weeknum_diff ) + ' weeks.\n'
		x = True
	send_data(message, client_conn)
	return x, ctr

def validdatefn(client_conn, option, ctr):
	valid_date = False
	weeknum_diff = -1
	date = option.split('/')
	if (len(date) == 3 and date[2].isnumeric() and date[1].isnumeric() and date[0].isnumeric()):
		try:
			tmp_date = datetime.datetime(int(date[2]), int(date[1]), int(date[0]))
			weeknum = int(datetime.date(int(date[2]), int(date[1]), int(date[0])).strftime("%W"))
			vaccination_weeknum = int(datetime.date.today().strftime("%W"))
			if ( int(date[2]) == 2021 ):
				weeknum_diff = vaccination_weeknum - weeknum
			elif ( int(date[2]) < 2021 ):
				weeknum_diff = ((2021 - int(date[2]) - 1) * 52) + (52 - weeknum) + vaccination_weeknum
			if ( weeknum_diff >= 0 and int(date[2]) <= 2021 ):
				valid_date = True
			else:
				handle_invalid_date(client_conn, date)
				valid_date = False
		except ValueError:
			handle_invalid_date(client_conn, date)
			valid_date = False
	else:
		handle_invalid_date(client_conn, date)
		valid_date = False
	return valid_date, date, weeknum_diff, ctr

def validoptionfn( client_conn, option, fetchfnxoutputdict, ctr, dict_usr_inp, arg_names, fnx_names, imessages, server_msgs):
	input_ctr = ctr
	value_of_option_selected = (fetchfnxoutputdict)[option]
	if ( isinstance(value_of_option_selected, str) ):
		server_msg_val = dict_usr_inp[arg_names[len(fnx_names) - ctr]] = value_of_option_selected.replace('Dose ', '')
		num_slots = -1 
	else:
		server_msg_val = dict_usr_inp[arg_names[len(fnx_names) - ctr]] = list(value_of_option_selected.keys())[0]
		num_slots = list(value_of_option_selected.values())[0]
	info_message = get_info_message(imessages, dict_usr_inp, arg_names, fnx_names, ctr)
	if ( num_slots == '0' ):
		info_message += '\n<<< Available Slots on the selected Date: ' + num_slots + '\n<<< Selected Appointment Date has no available slots, select another date!'
		ctr = ctr - 1
	if ( ctr == 5 ):
		info_message += '\n<<< Available Slots on the selected Date: ' + num_slots + '\n<<< Your appointment is scheduled. Make sure to carry ID Proof while you visit'
	send_data(info_message, client_conn)
	print(server_msgs[input_ctr], server_msg_val)
	if ( input_ctr == 5 ):
		print('Available Slots on that date:', num_slots)
	if (dict_usr_inp['dose'] == '2' and ctr == 0 ):
		x, ctr = handle_second_dose(client_conn, ctr)
		if (x):
			stopCommunication(client_conn)
			exit()
	return False, [], 0, ctr

def handleinput(fetchfnxoutputdict, option, inputisadate, client_conn, ctr, handlevalidcasefn, handlevalidcasefnargs):
	valid_date = False
	date = []
	weeknum_diff = -1
	valid_option = False
	#print(str(option))
	if ( (inputisvalidoption(fetchfnxoutputdict, option)) or (inputisadate)):
		#globals()['invalidinput'] = 0
		if ( option == 'b' or option == 'B' ):
			ctr -= 2
			valid_option = True
		elif ( option == 'q' or option == 'Q' ):
			valid_option = True
			stopCommunication(client_conn)
			exit()
		else:
			valid_date, date, weeknum_diff, ctr = handlevalidcasefn( client_conn, option, *handlevalidcasefnargs)
	else:
		if (globals()['invalidinput'] < 2):
			message = '\n<<< Invalid input provided ' + str(globals()['invalidinput'] + 1) + ' time(s)! Try again.'
			send_data(message, client_conn)
			globals()['invalidinput'] += 1
			ctr -= 1
		else:
			message = '\n<<< Invalid input provided ' + str(globals()['invalidinput'] + 1) + ' time(s)! Try again.'
			send_data(message, client_conn)
			stopCommunication(client_conn)
			exit()
	return valid_option, valid_date, date, weeknum_diff, ctr

##############################################################


if __name__ == '__main__':
	"""Main function, code begins here
	"""
	url_website = "https://www.mooc.e-yantra.org/task-spec/fetch-mock-covidpage"
	web_page_data = fetchWebsiteData(url_website)
	client_conn, client_addr = openConnection()
	startCommunication(client_conn, client_addr, web_page_data)
