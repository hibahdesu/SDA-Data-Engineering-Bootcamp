#!/usr/bin/env python
# coding: utf-8

# In[22]:


import requests
from bs4 import BeautifulSoup, NavigableString
import pandas as pd
import re


# In[10]:


def extract_asoup(url, parser='lxml'):
  page = requests.get(url)
  soup = BeautifulSoup(page.content, parser)
  return soup


# In[11]:


watches_url = "https://www.jaquet-droz.com/en/watches"


# In[12]:


soup = extract_asoup(watches_url, 'html.parser')


# In[13]:


links = soup.find_all('a', href=True)
watches_urls = [link['href'] for link in links if link['href'].startswith("https://www.jaquet-droz.com/en/watches/")]
watches_urls


# In[14]:


watches_data = []
for watch_url in watches_urls:
    watch_soup = extract_asoup(watch_url, 'html.parser')
    content = watch_soup.find('div', class_ = 'block block-system')
    if content == None:
        continue
    parent_model = content.find('h1').text
    item_list = content.find_all('a', href=True)
    urls =[link['href'] for link in item_list]
    for watch in urls:
        watch_URL = watch
        watch_infos = extract_asoup(watch, 'html.parser')
        watch_info = watch_infos.find('div', class_ = 'watch-infos')
        specific_model = watch_info.find('h1', class_ = 'title-node').text
        description = watch_info.find('div', class_ = 'description').text.strip()
        watch_spec = watch_info.find('div', class_ = 'watch-spec')
        features = watch_spec.find('th', text='Indications').find_next_sibling('td').text if watch_spec.find('th', text='Indications') else "None"
        jewels = watch_spec.find('th', text='Jewelling').find_next_sibling('td').text \
            if watch_spec.find('th', text='Jewelling') else ""
        frequency = watch_spec.find('th', text='Frequency').find_next_sibling('td').text if watch_spec.find('th', text='Frequency') else ""
        power_reserve = watch_spec.find('th', text='Power reserve').find_next_sibling('td').text if watch_spec.find('th', text='Power reserve') else ""
        caliber = watch_spec.find('th', text='Movement').find_next_sibling('td').text if watch_spec.find('th', text='Movement') else ""
        movement = caliber
        clasp_type = watch_spec.find('th', text='Buckle').find_next_sibling('td').text if watch_spec.find('th', text='Buckle') else ""
        bracelet_color = watch_spec.find('th', text='Strap').find_next_sibling('td').text if watch_spec.find('th', text='Strap') else ""
        bracelet_material = bracelet_color
        dial_color = watch_spec.find('th', text='Dial').find_next_sibling('td').text if watch_spec.find('th', text='Dial') else ""
        water_resistance = watch_spec.find('th', text=lambda text: text and 'resistance' in text).find_next_sibling('td').text if watch_spec.find('th', text=lambda text: text and 'resistance' in text) else ""
        case_thickness = watch_spec.find('th', text='Case').find_next_sibling('td').text if watch_spec.find('th', text='Case') else ""
        diameter = case_thickness
        case_material = case_thickness

        image_URL = watch_infos.find('div', class_='watch-picture').find('img').get('src')
        price ="N/A"
        currency = "N/A"
        brand = "Jaquet Droz"
        reference_number = watch_spec.find('th', text='Reference').find_next_sibling('td').text
        watches_data.append({
            "reference_number": reference_number,
            "watch_URL": watch_URL,
            "type": "",
            "brand": brand,
            "year_introduced": "",
            "parent_model": parent_model,
            "specific_model": specific_model,
            "nickname": "",
            "marketing_name": "",
            "style": "",
            "currency": currency,
            "price": price,
            "image_URL": image_URL,
            "made_in": "",
            "case_shape": "",
            "case_material": case_material,
            "case_finish": "",
            "caseback": "",
            "diameter": diameter,
            "between_lugs": "",
            "lug_to_lug": "",
            "case_thickness": case_thickness,
            "bezel_material": "",
            "bezel_color": "",
            "crystal": "",
            "water_resistance": water_resistance,
            "weight": "",
            "dial_color": dial_color,
            "numerals": "",
            "bracelet_material": bracelet_material,
            "bracelet_color": bracelet_color,
            "clasp_type": clasp_type,
            "caliber": caliber,
           "power_reserve": power_reserve,
           "frequency": frequency,
           "jewels": jewels,
           "features": features,
           "description": description,
           "short_description": "",
        })


# In[15]:


df_watches_data = pd.DataFrame(watches_data)
df_watches_data


# In[21]:


df_watches_data.to_csv('df_watches_data.csv', index=False, encoding='utf-8-sig')


# In[ ]:




