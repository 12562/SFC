
# No other modules apart from 'math' need to be imported
# as they aren't required to solve the assignment

# Import required module/s
import math


def computeDistance(x1, y1, x2, y2):
	"""Computes Euclidean distance between two points with precision upto 3 decimal places and prints it to STDOUT.

	Parameters
	----------
	x1 : float
		X-coordinate of 1st point
	y1 : float
		Y-coordinate of 1st point
	x2 : float
		X-coordinate of 2nd point
	y2 : float
		Y-coordinate of 2nd point
	
	Example
	-------
	>>> x1 = 10.4; y1 = 5.02
	>>> x2 = 5.12; y2 = 10.8
	>>> computeDistance( x1, y1, x2, y2 )
	Distance computed: 4.243
	"""
	
	##############	ADD YOUR CODE HERE	##############
	dist = math.sqrt( (x2 - x1) **2  + (y2 - y1) ** 2)	
	txt = "Distance computed: {distance:.3f}"
	print(txt.format(distance=round(dist, 3)))

	##################################################


if __name__ == "__main__":
	"""Main function, code begins here
	"""
	x1 = 10.4; y1 = 5.02
	x2 = 5.12; y2 = 10.8
	computeDistance(x1, y1, x2, y2)
