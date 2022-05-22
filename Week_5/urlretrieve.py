import urllib.request
local_filename, headers = urllib.request.urlretrieve('http://python.org/')
print(local_filename)
print(headers)
html = open(local_filename)
html.close()
