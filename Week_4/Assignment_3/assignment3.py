
# No other modules apart from 'csv' and 'datetime' need to be imported
# as they aren't required to solve the assignment

# Import required module/s
import csv
from datetime import datetime as dt


def readWorkSheet(file_name):
	"""Reads the input CSV file of Work Sheet and creates a mapping of date and office name where he worked.

	Parameters
	----------
	file_name : str
		CSV file name of Work Sheet

	Returns
	-------
	dict
		Mapping of the date and office name where he worked as { Key : Value } pair
	
	Example
	-------
	>>> csv_file_name = 'week4_assignment3_sample.csv'
	>>> print( readWorkSheet( csv_file_name ) )
	{
		'2021-03-26': 'A', '2021-04-01': 'B', '2021-04-20': 'B', '2021-04-04': '-', '2021-04-12': 'A', '2021-04-23': 'A', 
		'2021-04-03': 'B', '2021-03-29': 'A', '2021-03-28': '-', '2021-03-31': 'A', '2021-04-10': 'B', '2021-04-16': 'A', 
		'2021-04-24': 'B', '2021-04-11': '-', '2021-04-13': 'B'
	}
	"""

	date_office_name_mapping = {}
	input_file_obj = open(file_name, 'r')

	##############	ADD YOUR CODE HERE	##############
	csv_reader = csv.reader(input_file_obj, delimiter=',')
	for row in csv_reader:
		if ( row[0] != "date" ):
			year_ = int(row[0].split('-')[0])
			month_ = int(row[0].split('-')[1])
			date_ = int(row[0].split('-')[2])
			weekday = dt(year_, month_, date_).weekday()
			if (weekday == 6):
				date_office_name_mapping[row[0]] = '-'
			elif (weekday % 2):
				date_office_name_mapping[row[0]] = 'B'
			else:
				date_office_name_mapping[row[0]] = 'A'
	

	##################################################
	
	input_file_obj.close()

	return date_office_name_mapping


def calculateOfficeHrs(mapping_dict):
	"""Calculate the number of hours worked in office A and B with the given mapping of date and office name.

	Parameters
	----------
	mapping_dict : dict
		Mapping of the date and office name where he worked as { Key : Value } pair

	Returns
	-------
	tuple
		Number of hours worked in office A and B as pair
	
	Example
	-------
	>>> date_office_name_mapping = {
									'2021-03-26': 'A', '2021-04-01': 'B', '2021-04-20': 'B', '2021-04-04': '-', '2021-04-12': 'A', '2021-04-23': 'A', 
									'2021-04-03': 'B', '2021-03-29': 'A', '2021-03-28': '-', '2021-03-31': 'A', '2021-04-10': 'B', '2021-04-16': 'A', 
									'2021-04-24': 'B', '2021-04-11': '-', '2021-04-13': 'B'
								}
	>>> print( calculateOfficeHrs( date_office_name_mapping ) )
	(48, 36)
	"""

	no_hrs_office_A, no_hrs_office_B = 0, 0

	##############	ADD YOUR CODE HERE	##############
	for i in mapping_dict:
		if (mapping_dict[i] == "A"):
			no_hrs_office_A += 8
		elif(mapping_dict[i] == "B"):
			no_hrs_office_B += 6
	

	##################################################

	return (no_hrs_office_A, no_hrs_office_B)


def writeOfficeWorkSheet(mapping_dict, out_file_name):
	"""Writes a CSV file with date and office name where the person worked on each day.

	Parameters
	----------
	mapping_dict : dict
		Mapping of the date and office name where he worked as { Key : Value } pair
	out_file_name : str
		File name of CSV file for writing the data to
	"""

	output_file_obj = open(out_file_name, 'w')

	##############	ADD YOUR CODE HERE	##############
	output_file_obj.write('date,office_name\r\n')
	for i in mapping_dict:
		output_file_obj.write('%s,%s\r\n' % (i,mapping_dict[i]))
	
	

	##################################################

	output_file_obj.close()


if __name__ == "__main__":
	"""Main function, code begins here.
	"""
	csv_file_name = 'week4_assignment3_sample.csv'
	date_office_name_mapping = readWorkSheet(csv_file_name)
	print(date_office_name_mapping)
	total_hrs_office_A_B = calculateOfficeHrs(date_office_name_mapping)
	print(total_hrs_office_A_B)
	out_csv_file_name = 'output_week4_assignment3_sample.csv'
	writeOfficeWorkSheet(date_office_name_mapping, out_csv_file_name)
