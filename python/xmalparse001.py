from bs4 import BeautifulSoup
import requests

print("-----------------------------")

url = 'http://pablob-ubuntu18-001a.westus2.cloudapp.azure.com:18080/migrations'

response = requests.get(url)
soup = BeautifulSoup(response.content, 'lxml')
migrationId = soup.find_all('migrationId')
print (response)

BeautifulSoup.e``

