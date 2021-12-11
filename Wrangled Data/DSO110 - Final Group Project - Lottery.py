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


# ### Extract month, day, year, weekday, and quarter from 'Draw Date'.

# In[3]:


Winning_Numbers['month'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).month
Winning_Numbers.head()


# In[4]:


Winning_Numbers['day'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).day
Winning_Numbers.head()


# In[5]:


Winning_Numbers['year'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).year
Winning_Numbers.head()


# In[6]:


Winning_Numbers['weekday'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).dayofweek
Winning_Numbers.head()


# In[7]:


Winning_Numbers['quarter'] = pd.DatetimeIndex(Winning_Numbers['Draw Date']).quarter
Winning_Numbers.head()


# In[8]:


Winning_Numbers.info()


# ### Convert 'Winning Numbers' to string and then separate terms into individual columns (5).

# In[9]:


Winning_Numbers["Winning Numbers"]= Winning_Numbers["Winning Numbers"].astype(str)


# In[10]:


Winning_Numbers1 = Winning_Numbers['Winning Numbers'].str.split(' ', expand=True)


# In[11]:


Winning_Numbers1.head()


# In[12]:


Winning_Numbers1.info()


# In[22]:


Winning_Numbers1[0]= Winning_Numbers1[0].astype(int)
Winning_Numbers1[1]= Winning_Numbers1[1].astype(int)
Winning_Numbers1[2]= Winning_Numbers1[2].astype(int)
Winning_Numbers1[3]= Winning_Numbers1[3].astype(int)
Winning_Numbers1[4]= Winning_Numbers1[4].astype(int)
Winning_Numbers1.info()


# In[33]:


#frames = [Winning_Numbers, Winning_Numbers1]

result = pd.concat([Winning_Numbers1, Winning_Numbers], axis=1)


# In[34]:


result.head()


# ### Export data to excel file.

# In[35]:


result.to_excel("Winning_Numbers_Wrangled.xlsx")  


# In[38]:


import os
os. getcwd()


# In[ ]:




