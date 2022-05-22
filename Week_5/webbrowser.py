import webbrowser
import requests
login_url = 'https://www.mooc.e-yantra.org/login'
payload = {'email':'mohit12562@gmail.com', 'password':'UHTozJhd', '_token':'inxFghNVxvxdq84ONybKjCEkhlSRzJCMMHZryQVd'}
s = requests.session()
response = s.post(login_url, data = payload)
print(response.url)
print(response)
webbrowser.open(response.url)

