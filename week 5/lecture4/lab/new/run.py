### Importing the neccessary libraries

# In[1]:


# Import necessary libraries and modules for data manipulation, visualization, web scraping, and regular expressions.


import requests
from bs4 import BeautifulSoup, NavigableString
import pandas as pd
import re
import subprocess


# ### Extracting Data using BeautifulSoup

# In[2]:


def extract_asoup(url, parser='lxml'):
  # Send a GET request to the specified 'url' and retrieve the page content
  page = requests.get(url)

  # Create a BeautifulSoup object by parsing the 'page.content' using the specified 'parser'
  soup = BeautifulSoup(page.content, parser)

  # Return the resulting BeautifulSoup object
  return soup


# In[3]:


#Assigning the link to the website to a variable
watches_url = "https://www.jaquet-droz.com/en/watches"


# In[4]:


# Extract the HTML content from the specified 'watches_url' and parse it using 'html.parser'
soup = extract_asoup(watches_url, 'html.parser')


# ### Extract Watch URLs

# In[5]:


# Find all the <a> tags (hyperlinks) in the parsed HTML using BeautifulSoup
links = soup.find_all('a', href=True)

# Extract the URLs from the <a> tags that start with "https://www.jaquet-droz.com/en/watches/"
watches_urls = [link['href'] for link in links if link['href'].startswith("https://www.jaquet-droz.com/en/watches/")]

watches_urls.reverse()

#Let's see the links we have extract
watches_urls


# In[6]:


#Creating a empty list to save the data of the watches in it
watches_data = []
# Loop through each watch URL
for watch_url in watches_urls:
    # Extract the watch details from the URL
    watch_soup = extract_asoup(watch_url, 'html.parser')
    content = watch_soup.find('div', class_ = 'block block-system')

    # Skip to the next iteration if content is None
    if content is None:
        continue

    # Extract the parent model information
    parent_model = content.find('h1').text

    # Extract the URLs of related watches
    item_list = content.find_all('a', href=True)
    urls =[link['href'] for link in item_list]

    # Loop through each related watch URL
    for watch in urls:
        watch_URL = watch

        # Extract the watch information from the related watch URL
        watch_infos = extract_asoup(watch, 'html.parser')
        watch_info = watch_infos.find('div', class_ = 'watch-infos')

        # Extract various details of the watch
        specific_model = watch_info.find('h1', class_ = 'title-node').text
        description = watch_info.find('div', class_ = 'description').text.strip()
        watch_spec = watch_info.find('div', class_ = 'watch-spec')
        reference_number = watch_spec.find('th', text='Reference').find_next_sibling('td').text
        if any(item.get("reference_number") == reference_number for item in watches_data):
            continue
        features = watch_spec.find('th', text='Indications').find_next_sibling('td').text if watch_spec.find('th', text='Indications') else None
        jewels = watch_spec.find('th', text='Jewelling').find_next_sibling('td').text \
            if watch_spec.find('th', text='Jewelling') else None
        frequency = watch_spec.find('th', text='Frequency').find_next_sibling('td').text if watch_spec.find('th', text='Frequency') else None
        power_reserve = watch_spec.find('th', text='Power reserve').find_next_sibling('td').text if watch_spec.find('th', text='Power reserve') else None
        caliber = watch_spec.find('th', text='Movement').find_next_sibling('td').text if watch_spec.find('th', text='Movement') else None
        movement = caliber
        clasp_type = watch_spec.find('th', text='Buckle').find_next_sibling('td').text if watch_spec.find('th', text='Buckle') else None
        bracelet_color = watch_spec.find('th', text='Strap').find_next_sibling('td').text if watch_spec.find('th', text='Strap') else None
        bracelet_material = bracelet_color
        dial_color = watch_spec.find('th', text='Dial').find_next_sibling('td').text if watch_spec.find('th', text='Dial') else None
        water_resistance = watch_spec.find('th', text=lambda text: text and 'resistance' in text).find_next_sibling('td').text if watch_spec.find('th', text=lambda text: text and 'resistance' in text) else None
        case_thickness = watch_spec.find('th', text='Case').find_next_sibling('td').text if watch_spec.find('th', text='Case') else None
        diameter = case_thickness
        case_material = case_thickness

        image_URL = watch_infos.find('div', class_='watch-picture').find('img').get('src')
        price =""
        currency = ""
        brand = "Jaquet Droz"
        reference_number = watch_spec.find('th', text='Reference').find_next_sibling('td').text


         # Update the list of URLs based on variant colors
        another_colors_watch = watch_infos.find('div', class_='variantes')
        if watch_infos.select('div.variantes li.variante:not(.active)'):
            list_colors = [li.find('a')['href'] for li in watch_infos.select('div.variantes li.variante:not(.active)')]

            index = urls.index(watch)+1
            urls[index:index] = [item for item in list_colors if item not in urls]


        # Append the extracted watch data to the watches_data list
        watches_data.append({

            "reference_number": reference_number,
            "watch_URL": watch_URL,
            "type": '',
            "brand": brand,
            "year_introduced": '',
            "parent_model": parent_model,
            "specific_model": specific_model,
            "nickname": '',
            "marketing_name": '',
            "style": '',
            "currency": currency,
            "price": price,
            "image_URL": image_URL,
            "made_in": '',
            "case_shape": '',
            "case_material": case_material,
            "case_finish": '',
            "caseback": '',
            "diameter": diameter,
            "between_lugs": '',
            "lug_to_lug": '',
            "case_thickness": case_thickness,
            "bezel_material": '',
            "bezel_color": '',
            "crystal": '',
            "water_resistance": water_resistance,
            "weight": '',
            "dial_color": dial_color,
            "numerals": '',
            "bracelet_material": bracelet_material,
            "bracelet_color": bracelet_color,
            "clasp_type": clasp_type,
            "movement" : movement,
            "caliber": caliber,
           "power_reserve": power_reserve,
           "frequency": frequency,
           "jewels": jewels,
           "features": features,
           "description": description,
           "short_description": '',
        })


# In[7]:


#Creating a dataframe (watches details) from the data we got from the website
df_watches_data = pd.DataFrame(watches_data)

#Seeing the dataframe (watches details)
df_watches_data


# In[8]:


#Converting (Saving) the dataframe (watches data) in a csv file

df_watches_data.to_csv('df_watches_data.csv', index=False, encoding='utf-8-sig')


# <hr>

# In[9]:


#Reading the data from a csv file
df = pd.read_csv('df_watches_data.csv')

#Seeing the dataframe
df.head()


# In[10]:


result = df[df['specific_model'] == 'The Rolling Stones Automaton']
result


# In[11]:


ref = df[df['reference_number'] == 'J031033211']
ref


# In[12]:


reference_unique = df['reference_number'].unique()
reference_unique


# In[13]:


#Seeing the info our the watches
df.info()


# In[14]:


#Checking for the null (missing) features in our watches' data
df.isna().sum()
#We can notice that, some of the watches do not have some features and the website did not put them as No.
#So, because of that they are missing


bucket='pro-rcp'
folder='input'


subprocess.call(['aws','s3','cp','df_watches_data.csv', 's3://pro-rcp/input/df_watches_data.csv'])

# <hr>
