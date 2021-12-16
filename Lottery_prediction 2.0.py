#!/usr/bin/env python
# coding: utf-8

# # DSO110 - Final Project - Lottery Prediction

# In[1]:


import pandas as pd 
import numpy as np
from matplotlib import pyplot
import warnings
import re
import matplotlib.pyplot as plt
get_ipython().run_line_magic('matplotlib', 'inline')
from sklearn.ensemble import GradientBoostingClassifier, RandomForestClassifier, AdaBoostClassifier
from sklearn.model_selection import cross_val_predict, cross_val_score, train_test_split
# from xgboost import XGBClassifier
import seaborn as sns 


# In[2]:


df = pd.read_csv('Lottery_Mega_Millions_Winning_Numbers__Beginning_2002.csv')


# In[3]:


df.head()


# In[4]:


df.isnull().sum()


# In[5]:


df.describe()


# In[6]:


df.set_index('Draw Date',inplace=True)


# In[7]:


df


# In[8]:


df2 = df.drop(["Month","Day","Year","Weekday","Weekday.1","Quarter",'First','Second','Third','Fourth','Fifth'],axis=1)


# In[9]:


df2


# In[10]:


d2 = df2['Winning Numbers']
df2[['Ball1','Ball2',"Ball3","Ball4","Ball5"]] =  df2["Winning Numbers"].str.split(" ", n=4, expand=True)
df2


# In[11]:


winning_numbers = df2.drop(['Winning Numbers'],axis=1)


# In[12]:


winning_numbers


# In[13]:


winning_numbers['Ball1'] =winning_numbers['Ball1'].astype('category')
winning_numbers['Ball2'] =winning_numbers['Ball2'].astype('category')
winning_numbers['Ball3'] =winning_numbers['Ball3'].astype('category')
winning_numbers['Ball4'] =winning_numbers['Ball4'].astype('category')
winning_numbers['Ball5'] =winning_numbers['Ball5'].astype('category')

cat_feat = ['Mega Ball','Multiplier']
for feat in cat_feat:
    winning_numbers[feat] = winning_numbers[feat].astype('category')


# In[14]:


winning_numbers.info()


# In[15]:


winning_numbers = winning_numbers.rename(columns={'Mega Ball':'MegaBall',"Multiplier":"Bonus"}, errors="raise")


# In[16]:


X = winning_numbers.drop(["MegaBall"],axis=1)
y = winning_numbers['MegaBall']


# In[17]:


from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix
models = []
models.append(("LR",LogisticRegression(solver='liblinear')))
print(models)


# In[18]:


# import statsmodels.formula.api as smf
# model_fit3 = smf.logit(formula='MegaBall ~C(Ball1)+C(Ball2)', data=winning_numbers).fit()


# In[ ]:




