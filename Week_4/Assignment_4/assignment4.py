
# No other modules apart from 'csv' need to be imported
# as they aren't required to solve the assignment

# Import required module/s
import csv

def readMarkSheet(file_name):
	"""Reads the input CSV file of Mark Sheet and creates a mapping of student name with his/her marks for each subject.

	Parameters
	----------
	file_name : str
		CSV file name of Mark Sheet

	Returns
	-------
	dict
		Mapping of each student's name and his/her marks for each subject as { Key : Value } pair
	
	Example
	-------
	>>> csv_file_name = 'week4_assignment4_sample.csv'
	>>> print( readMarkSheet( csv_file_name ) )
	{
		'Artus Syne': {'marks': [43.0, 71.0, 55.0, 16.0, 51.0]}, 'Evey Reburn': {'marks': [49.0, 7.0, 53.0, 50.0, 63.0]}, 
		'Giff Wickmann': {'marks': [63.0, 37.0, 21.0, 87.0, 9.0]}, 'Garrot Casetta': {'marks': [22.0, 3.0, 91.0, 75.0, 52.0]}, 
		'Roselle Maes': {'marks': [71.0, 90.0, 96.0, 79.0, 48.0]}, 'Torin Ziehms': {'marks': [71.0, 31.0, 83.0, 1.0, 25.0]}, 
		'Jaye Etock': {'marks': [92.0, 9.0, 2.0, 78.0, 55.0]}, 'Thomasina Tinkham': {'marks': [25.0, 78.0, 46.0, 46.0, 90.0]}, 
		'Adolphus Biernat': {'marks': [91.0, 96.0, 98.0, 94.0, 100.0]}, 'Rex Aspinell': {'marks': [34.0, 75.0, 51.0, 38.0, 99.0]}
	}
	"""

	name_marks_mapping = {}
	input_file_obj = open(file_name, 'r')

	##############	ADD YOUR CODE HERE	##############
	csv_reader = csv.reader(input_file_obj, delimiter=',')
	for row in csv_reader:
		if (row[0] != "name"):
			name_marks_mapping[row[0]] = {'marks':  [float(row[1]), float(row[2]), float(row[3]), float(row[4]), float(row[5])]}	

	##################################################
	
	input_file_obj.close()

	return name_marks_mapping


def generateGradeCard(mapping_dict):
	"""Generate the Grade Card for all students in the given mapping of student and their scores in all subjects with the grade each one has received.

	Parameters
	----------
	mapping_dict : dict
		Mapping of each student's name and his/her marks for each subject as { Key : Value } pair

	Returns
	-------
	dict
		Grade Card for all students with their scores in all subjects and the grade each one has received
	
	Example
	-------
	>>> name_marks_mapping = {
								'Artus Syne': {'marks': [43.0, 71.0, 55.0, 16.0, 51.0]}, 'Evey Reburn': {'marks': [49.0, 7.0, 53.0, 50.0, 63.0]}, 
								'Giff Wickmann': {'marks': [63.0, 37.0, 21.0, 87.0, 9.0]}, 'Garrot Casetta': {'marks': [22.0, 3.0, 91.0, 75.0, 52.0]}, 
								'Roselle Maes': {'marks': [71.0, 90.0, 96.0, 79.0, 48.0]}, 'Torin Ziehms': {'marks': [71.0, 31.0, 83.0, 1.0, 25.0]}, 
								'Jaye Etock': {'marks': [92.0, 9.0, 2.0, 78.0, 55.0]}, 'Thomasina Tinkham': {'marks': [25.0, 78.0, 46.0, 46.0, 90.0]}, 
								'Adolphus Biernat': {'marks': [91.0, 96.0, 98.0, 94.0, 100.0]}, 'Rex Aspinell': {'marks': [34.0, 75.0, 51.0, 38.0, 99.0]}
							}
	>>> print( generateGradeCard( name_marks_mapping ) )
	{
		'Artus Syne': {'subject_wise_marks': [43.0, 71.0, 55.0, 16.0, 51.0], 'grade_received': 'D'}, 
		'Evey Reburn': {'subject_wise_marks': [49.0, 7.0, 53.0, 50.0, 63.0], 'grade_received': 'D'}, 
		'Giff Wickmann': {'subject_wise_marks': [63.0, 37.0, 21.0, 87.0, 9.0], 'grade_received': 'D'}, 
		'Garrot Casetta': {'subject_wise_marks': [22.0, 3.0, 91.0, 75.0, 52.0], 'grade_received': 'D'}, 
		'Roselle Maes': {'subject_wise_marks': [71.0, 90.0, 96.0, 79.0, 48.0], 'grade_received': 'A'}, 
		'Torin Ziehms': {'subject_wise_marks': [71.0, 31.0, 83.0, 1.0, 25.0], 'grade_received': 'D'}, 
		'Jaye Etock': {'subject_wise_marks': [92.0, 9.0, 2.0, 78.0, 55.0], 'grade_received': 'D'}, 
		'Thomasina Tinkham': {'subject_wise_marks': [25.0, 78.0, 46.0, 46.0, 90.0], 'grade_received': 'C'}, 
		'Adolphus Biernat': {'subject_wise_marks': [91.0, 96.0, 98.0, 94.0, 100.0], 'grade_received': 'O'}, 
		'Rex Aspinell': {'subject_wise_marks': [34.0, 75.0, 51.0, 38.0, 99.0], 'grade_received': 'C'}
	}
	"""

	grade_card = {}

	##############	ADD YOUR CODE HERE	##############
	for i in mapping_dict:
		#mapping_dict[i] = [float(j) for j in mapping_dict[i]]
		percentage = sum(mapping_dict[i]['marks']) / 5;
		if ( percentage >= 90 ):
			grade = "O"
		elif ( percentage >= 70 ):
			grade = "A"
		elif ( percentage >= 60 ):
			grade = "B"
		elif ( percentage >= 50 ):
			grade = "C"
		elif ( percentage >= 40 ):
			grade = "D"
		else:
			grade = "Fail"
		grade_card[i] = {'subject_wise_marks' : mapping_dict[i]['marks'], 'grade_received' : grade}
		
	

	##################################################

	return grade_card


if __name__ == "__main__":
	"""Main function, code begins here.
	"""
	csv_file_name = 'week4_assignment4_sample.csv'
	name_marks_mapping = readMarkSheet(csv_file_name)
	print(name_marks_mapping)
	grade_card = generateGradeCard(name_marks_mapping)
	print(grade_card)
