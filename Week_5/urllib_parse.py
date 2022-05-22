from urllib.parse import urlparse
result = urlparse('https://duckduckgo.com/?q=python')
print(result.netloc)
print(result.geturl())
print(result.port)
