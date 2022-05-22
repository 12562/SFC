import urllib.request
import urllib.parse
data = urllib.parse.urlencode({'q': 'Python'})
print(data)
url = 'http://duckduckgo.com/html'
full_url = url + '?' + data
response = urllib.request.urlopen(full_url)
with open('/home/mohit/Downloads/e-yantra_mooc/Week_5/query_results', 'wb') as f:
  f.write(response.read())
