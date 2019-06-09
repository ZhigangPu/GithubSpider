#!/usr/bin/python3
# coding: utf-8

# This program is intended to get latest trending projects on github -- their names, aims and locations.



import re
import csv
import requests
from lxml import etree

url = 'https://github.com/trending'
headers = {'content-type':'application/json'}

r = requests.get(url, headers=headers)
html = etree.HTML(r.text)
result = etree.tostring(html)


projects_num = len(html.xpath('//ol[@class="repo-list"]//li//h3/a/@href')) # 根据项目名称数目判断项目总数
projects = []
for i in range(projects_num):
    name_path = '//ol[@class="repo-list"]//li[{}]//h3/a/@href'.format(i+1)
    raw_name = html.xpath(name_path)
    refined_name = raw_name[0]   # TODO 不是很易读，隔了几天就不知道是什么意思了，需要拿到原始材料才能想到
    _, author, project = refined_name.split('/')
    link = 'https://github.com/{author}/{project}'.format(author=author, project=project)
    
    raw_description = html.xpath('//ol[@class="repo-list"]//li[{}]//p//text()'.format(i+1))
    refined_description = max(raw_description, key=len) if raw_description else ''
    
    star_path = '//ol[@class="repo-list"]//li[{}]//span[@class="d-inline-block float-sm-right"]//text()'.format(i+1)
    raw_star = max(html.xpath(star_path), key=len)
    refined_star = re.search('(\d+)\w+', raw_star.replace(',','')).group(0)
    

    projects.append({'author':author, 'project':project, 'description':refined_description.strip(), 'star':refined_star, 'link':link})


with open('projects.csv', 'w') as csv_file:
    writer = csv.DictWriter(csv_file, fieldnames=['author', 'project', 'description', 'star', 'link'])
    writer.writeheader()
    for project in projects:
        writer.writerow(project)


