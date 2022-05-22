
# No other modules apart from 'bs4' and 'requests' need to be imported
# as they aren't required to solve the assignment

# Import required module/s
from bs4 import BeautifulSoup
import requests


def getUserName(url_website, full_name):
	"""Gets the username from a website of the person whose full name is provided as input.

	Parameters
	----------
	url_website : str
		URL of website to scrape
	full_name : str
		Full name of person whose username is to be returned by scraping the given website

	Returns
	-------
	str
		Username of person for the provided Full name
	
	Example
	-------
	>>> url_website = "https://www.cse.iitb.ac.in/archive/page222?batch=MTech1"
	>>> full_name = "PRIYANSH KIMTEE"
	>>> getUserName(url_website, full_name)
	priyansh

	>>> url_website = "https://www.cse.iitb.ac.in/archive/page222?batch=MTech1"
	>>> full_name = "AKASH VERMA"
	>>> getUserName(url_website, full_name)
	Full Name does not exist on website
	"""

	username = ""

	##############	ADD YOUR CODE HERE	##############
	req = requests.get(url_website)	
	soup = BeautifulSoup(req.text, 'html.parser')
	for a in soup.find_all('a', text=full_name):
	    username = a.attrs['href'][2:]
	if username == "":
           username = "Full Name does not exist on website"
	##################################################

	return username


if __name__ == "__main__":
	"""Main function, code begins here
	"""
	url_website = "https://www.cse.iitb.ac.in/archive/page222?batch=MTech1"
	#full_name = "A.V.S BHARADWAJ"
	full_name = "ABHISHEK"

	username = getUserName(url_website, full_name)
	print("The username of " + full_name + " is: " + username)
