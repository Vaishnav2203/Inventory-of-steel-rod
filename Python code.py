import pandas as pd
data = pd.read_csv(r"C:\Users\SONIYA\Desktop\Dataset.csv")
data.head()
data.tail()
data.describe()
data.info()

''' Mode of Categorical data '''

# MODE OF FY
data.FY.mode()

# MEDIAN OF FY
data.Dia.median()

# MODE OF Customer_Name
data.Customer_Name.mode()

# MODE OF Dia
data.Dia.mode()

# MODE OF Dia_group
data.Dia_group.mode()

# MODE OF Grade
data.Grade.mode()

# MODE OF Type
data.Type.mode()

# MODE OF Length
data.Length.mode()


"""         Quantity               """

''' 1st Movement Business Decision - Measure of Central Tendency '''

Mean = data.Quantity.mean()

Median = data.Quantity.median()

mode = data.Quantity.mode()

''' 2nd Movement Business Decision - Measure of Despersion '''

Variance = data.Quantity.var()

Standard_deviation = data.Quantity.std()

Range = max(data.Quantity) - min(data.Quantity)

''' 3rd Movement Business Decision - Skewness '''

Skewness = data.Quantity.skew()

''' 4th Movement Business Decision - Kurtosis '''

Kurtosis = data.Quantity.kurt()


"""            Rate              """

''' 1st Movement Business Decision - Measure of Central Tendency '''

Mean = data.Rate.mean()

Median = data.Rate.median()

Mode = data.Rate.mode()

''' 2nd Movement Business Decision - Measure of Despersion '''

Variance = data.Rate.var()

Standard_deviation = data.Rate.std()

Range = max(data.Rate) - min(data.Rate)

''' 3rd Movement Business Decision - Skewness '''

Skewness = data.Rate.skew()

''' 4th Movement Business Decision - Kurtosis '''

Kurtosis = data.Rate.kurt()


''' Missing Value Deduction '''

data.FY.isnull().sum()

data.Customer_Name.isnull().sum()   

data.Dia.isnull().sum()

data.Dia_group.isnull().sum()

data.Grade.isnull().sum()

data.Type.isnull().sum()

data.Length.isnull().sum()

data.Quantity.isnull().sum()

data.Rate.isnull().sum()


''' Outlier Detection '''
import numpy as np

' Outlier of Quantity '

Q1 = data['Quantity'].quantile(0.25)
Q3 = data['Quantity'].quantile(0.75)

IQR = data['Quantity'].quantile(0.75) - data['Quantity'].quantile(0.25)
 
Lower_limit = data['Quantity'].quantile(0.25) - (IQR * 1.5)
Upper_limit = data['Quantity'].quantile(0.75) + (IQR * 1.5)

Outlier_data = np.where(data.Quantity > Upper_limit , True , np.where(data.Quantity < Lower_limit , True , False))
data_out = data.loc[Outlier_data, ]
len(data_out)

import seaborn as sns
import matplotlib.pyplot as plt

sns.boxplot(data.Quantity)
plt.title('Quantity')

' Outlier of Rate '

Q1 = data['Rate'].quantile(0.25)
Q3 = data['Rate'].quantile(0.75)

IQR = data['Rate'].quantile(0.75) - data['Rate'].quantile(0.25)

Lower_limit = data['Rate'].quantile(0.25) - (IQR * 1.5)
Upper_limit = data['Rate'].quantile(0.75) + (IQR * 1.5)

outlier_data = np.where(data.Rate > Upper_limit , True , np.where(data.Rate < Lower_limit , True , False)) 
data_out = data.loc[outlier_data, ]
len(data_out)

import seabien as sns
import matplotlip.pyplot as plt

sns.boxplot(data.Rate)
plt.title('Rate')

data.shape

sns.boxplot(data.Grade)
sns.distplot(data.Quantity,  axlabel='FY', color = 'purple' , hist_kws={"edgecolor" : 'black'})
sns.distplot(data.Rate , axlabel = 'Rate' , color = 'purple' , hist_kws = {"edgecolor" : 'black'})
