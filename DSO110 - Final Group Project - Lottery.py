#!/usr/bin/env python
# coding: utf-8

# # DSO110 - Final Group Project - Lottery
# Alberta "Albi" Kovatcheva and Barbra Treston
# 
# 
# 
# ## Background
# Albi and Barbra have chosen the “Mega Millions Winning Numbers” dataset because the lottery is something that is familiar and accessible to a wide range of people worldwide; it would be difficult to find someone who hasn’t dreamed of hitting the jackpot and changing their life forever. However, it is also widely accepted that the lottery is not set up to favor the player.  In the case of Mega Millions, although there is a 1 in 24 chance of winning something, the odds of choosing all 6 numbers correctly to win the jackpot is 1 in 302,575,350 - a fact that is posted openly on both the New York Lottery and Mega Millions websites.  By analyzing the winning numbers data as well as complementary datasets on lottery retailers, lottery aid to local school districts, and monies recouped from the lottery winnings of public aid recipients, Albi and Barbra hope to glean insight to make actionable suggestions on how lottery players can get the best return on their investment as well as to demonstrate for the average person whether the lottery serves any societal good or whether it may be best to abstain from playing altogether. 
# 
# 
# 
# ## Data Wrangling
# The data must be wrangled/formatted to be suitable for analysis.
# 
# Tasks:
# 1. From 'Draw Date', extract the month.
# 2. From 'Draw Date', extract the day.
# 3. From 'Draw Date', extract the year.
# 4. From 'Draw Date', extract the weekday.
# 5. From 'Draw Date', extract the quarter.
# 6. Separate the 'Winning Numbers' column, into 5 columns, with each containing one of the winning numbers in their corresponding order of being drawn.

# ### Import data.

# In[1]:


import pandas as pd
import seaborn as sns
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import math
import numpy as np
from numpy import nan
import datetime as dt
from datetime import date


# In[2]:


Winning_Numbers = pd.read_csv("C:/Users/albi/Downloads/lottery/Lottery_Mega_Millions_Winning_Numbers__Beginning_2002.csv")

pd.set_option("display.max_columns", None)

Winning_Numbers.head()


# ### Tasks 1-5: Extract month, day, year, weekday, and quarter from 'Draw Date'.
# #### 1. Extract month from 'Draw Date'.

# In[3]:


Winning_Numbers['month'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).month
Winning_Numbers.head()


# #### 2. Extract day from 'Draw Date'.

# In[4]:


Winning_Numbers['day'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).day
Winning_Numbers.head()


# #### 3. Extract year from 'Draw Date'.

# In[5]:


Winning_Numbers['year'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).year
Winning_Numbers.head()


# #### 4. Extract weekday from 'Draw Date'.

# In[6]:


Winning_Numbers['weekday'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).dayofweek
Winning_Numbers.head()


# #### 5. Extract quarter from 'Draw Date'.

# In[7]:


Winning_Numbers['quarter'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).quarter
Winning_Numbers.head()


# ### Task 6: Convert 'Winning Numbers' to string and then separate terms into individual columns (5).
# Determine the data types in the "Winning_Numbers" data frame.
# To accomplish this task, the 'Winning Numbers' data must be of the string type.

# In[8]:


Winning_Numbers.info()


# Winning_Numbers.info() shows that the 'Winning Numbers' data is of the object type. Below, it is converted to string type.

# In[9]:


Winning_Numbers["Winning Numbers"]= Winning_Numbers["Winning Numbers"].astype(str)


# After the 'Winning Numbers' data is converted to string type, it is split into individual columns.

# In[10]:


Winning_Numbers1 = Winning_Numbers['Winning Numbers'].str.split(' ', expand=True)


# Below is the output of this operation.

# In[11]:


Winning_Numbers1.head()


# Winning_Numbers.info() is used to verify the data types in the "Winning_Numbers1" data frame.

# In[12]:


Winning_Numbers1.info()


# To prevent a NaN value, the winning numbers are converted into the integer data type.

# In[22]:


Winning_Numbers1[0]= Winning_Numbers1[0].astype(int)
Winning_Numbers1[1]= Winning_Numbers1[1].astype(int)
Winning_Numbers1[2]= Winning_Numbers1[2].astype(int)
Winning_Numbers1[3]= Winning_Numbers1[3].astype(int)
Winning_Numbers1[4]= Winning_Numbers1[4].astype(int)
Winning_Numbers1.info()


# Here, the Winning_Numbers & Winning_Numbers1 dataframes are concatenated together.

# In[33]:


result = pd.concat([Winning_Numbers1, Winning_Numbers], axis=1)

#frames = [Winning_Numbers, Winning_Numbers1]


# In[34]:


result.head()


# ### Export data to excel file.

# In[35]:


result.to_excel("Winning_Numbers_Wrangled.xlsx")  


# In[38]:


import os
os. getcwd()


# Now that this data is wrangled, it is ready for use in analysis.

# In[ ]:




