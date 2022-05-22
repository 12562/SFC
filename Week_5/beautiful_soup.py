import requests
from bs4 import BeautifulSoup
req = requests.get('http://www.cse.iitb.ac.in')
soup = BeautifulSoup(req.text, 'html.parser')
print(soup.title)
print(soup.find_all('a'))
print("\n\n\n\n\n************************************\n\n\n\n\n")
head_tag = soup.head
head_tag.contents
print("\n\n\n\n\n************************************\n\n\n\n\n")
for sstrings in head_tag.stripped_strings:
    print(sstrings)
print("\n\n\n\n\n************************************\n\n\n\n\n")
print(soup.get_text())
