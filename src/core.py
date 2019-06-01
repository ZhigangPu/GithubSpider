#! /usr/bin/python3
# author: ayron.pu

import requests

url = 'https://github.com/explore?since=daily#trending'

headers = {}
headers['Content-type'] = 'application/json'

r = requests.get(url=url, headers=headers)

