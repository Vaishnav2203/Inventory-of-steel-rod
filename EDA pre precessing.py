'''--- Data Pre Processing ---'''

import pandas as pd
data = pd.read_csv(r"C:\Users\SONIYA\OneDrive\Desktop\Dataset.csv")
data.shape
data.describe()
data.info()

'''-----Handaling Missing Values-----'''
import pandas as pd
import numpy as np

data.isnull().sum()

from sklearn.impute import SimpleImputer

# Quantity - Median Imputation 
median_imputer = SimpleImputer(missing_values = np.nan , strategy = 'median')
data["Quantity"] = pd.DataFrame(median_imputer.fit_transform(data[["Quantity"]]))
data["Quantity"].isnull().sum() # replace all the missing value with median value


# Rate - Mean Imputation
mean_imputer = SimpleImputer(missing_values = np.nan , strategy = 'mean')
data["Rate"] = pd.DataFrame(mean_imputer.fit_transform(data[["Rate"]]))
data["Rate"].isnull().sum() # replace all the missing value with mean values

data.isna().sum()

'''  Handling Dublicates '''

# Duplicate Rows
duplicate_rows = data.duplicated(keep = 'first')
sum(duplicate_rows)

# Removing Duplicates
data = data.drop_duplicates(keep = 'first')
duplicate_rows = data.duplicated(keep = 'first')
sum(duplicate_rows)
data.shape

# Duplicate columns
data2 = pd.read_csv(r"C:\Users\SONIYA\Desktop\Book1.csv")
data2.corr() # Low correlation

''' Zero Variance And Near Zero Variance '''
data.Dia.value_counts() <= 1
data.Dia_group.value_counts() <= 1
data.Grade.value_counts() <= 1
data.Type.value_counts() <= 1
data.Length.value_counts() <= 1

'''-----Handaling Outliers-----'''

# Quantity 

# ---Outlier----
Q1 = data['Quantity'].quantile(0.25)
Q3 = data['Quantity'].quantile(0.75)

IQR = data['Quantity'].quantile(0.75) - data['Quantity'].quantile(0.25)

Lower_limit = data['Quantity'].quantile(0.25) - (IQR * 1.5)
Upper_limit = data['Quantity'].quantile(0.75) + (IQR * 1.5)

outlier_data = np.where(data.Quantity > Upper_limit , True , np.where(data.Quantity < Lower_limit , True , False)) 
data_out = data.loc[outlier_data, ]
len(data_out)

import seaborn as sns
import matplotlib.pyplot as plt

sns.boxplot(data.Quantity)
plt.title('Quantity')

sns.distplot(data.Quantity , axlabel = 'Quantity' , color = 'purple' , hist_kws = {"edgecolor" : 'black'})

# ----Treatment of outlier-----
# There is 3619 outlier present in Quantity columns 


# Rate

# ---Outlier----
Q1 = data.Rate.quantile(0.25)
Q1 = data['Rate'].quantile(0.25)
Q3 = data['Rate'].quantile(0.75)

IQR = data['Rate'].quantile(0.75) - data['Rate'].quantile(0.25)
IQR = Q3 - Q1

Lower_limit = data['Rate'].quantile(0.25) - (IQR * 1.5)
Upper_limit = data['Rate'].quantile(0.75) + (IQR * 1.5)

Lower_limit = Q1 - (IQR * 1.5)
Upper_limit = Q3 + (IQR * 1.5)

outlier_data = np.where(data.Rate > Upper_limit , True , np.where(data.Rate < Lower_limit , True , False)) 
data_out = data.loc[outlier_data, ]
len(data_out)

import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

sns.boxplot(data.Rate)
plt.title('Rate')

sns.distplot(data.Rate , axlabel = 'Rate' , color = 'purple' , hist_kws = {"edgecolor" : 'black'})

# Winsorization
from feature_engine.outliers import Winsorizer

winsor_iqr = Winsorizer(capping_method = 'iqr',
                        tail = 'both',
                        fold = 1.5,
                        variables = ['Rate'])

data['Rate'] = winsor_iqr.fit_transform(data[['Rate']])

import seaborn as sns
import matplotlib.pyplot as plt

sns.boxplot(data.Rate)
plt.title('Rate')

sns.distplot(data.Rate , axlabel = 'Rate' , color = 'purple' , hist_kws = {"edgecolor" : 'black'})


''' TRANSFROMATION '''

# Normal Q-Q Plot

import pandas as pd
import scipy.stats as stats
import pylab
import matplotlib.pyplot as plt
import seaborn as sns 


'''---Quantity---'''
stats.probplot(data.Quantity , dist = "norm" , plot = pylab)

# LOG Ttansformation
stats.probplot(np.log(data.Quantity) , dist ="norm" , plot = pylab)
Quantity = np.log(data.Quantity)

fix , ax = plt.subplots(1 , 2)
sns.distplot(data.Quantity , hist = False , kde = True, #kde: kernel density estimarion
             kde_kws = {'shade' : True , 'linewidth' : 2 ,},
             label = "Non-Normal" , color = 'green' , ax = ax[0] )
sns.distplot(Quantity , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "Normal" , color = 'green', ax = ax[1])


# Box Cox Transformation - data contain negative values
# Replacement of negative value with median value
import numpy as np
data['Quantity'] = pd.DataFrame(np.where(data['Quantity'] < 0 , data.Quantity.median(), data['Quantity']))

fitted_data, fitted_lamda = stats.boxcox(data.Quantity)

# Yeo-Johnson Transformation

from feature_engine import transformation
tf = transformation.YeoJohnsonTransformer(variables = 'Quantity') 
tf = tf.fit_transform(data)

stats.probplot(tf.Quantity , dist = "norm" , plot = pylab)

fix , ax = plt.subplots(1 , 2)
sns.distplot(data.Quantity , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "Non-Normal" , color = 'green' , ax = ax[0])
sns.distplot(tf.Quantity , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "Normal" , color = 'green' , ax = ax[1] )

sns.distplot(tf.Quantity , axlabel = 'Quantity' , color = 'purple' , hist_kws = {"edgecolor" : 'black'})


''' I would prefer Yeo Johson trasformation as compare to   tansformation yeo johson give more normal distribution, 
    after log transformation data is still non normally distributed'''


'''---Rate---'''

stats.probplot(data.Rate , dist = "norm" , plot = pylab)
sns.distplot(data.Rate , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "RATE" , color ='green')

#---LOG Transformatiom
import pandas as pd
import numpy as np

Rate = np.log(data.Rate)

#Q-Q Plot
stats.probplot(np.log(data.Rate) , dist = "norm" , plot = pylab)
# dinsity plot
sns.distplot(Rate , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "RATE" , color ='green')

#--=Box Cox Transformation
fitted_data, fitted_lamda = stats.boxcox(data.Quantity)

#Q-Q Plot
stats.probplot(fitted_data , dist = "norm" , plot = pylab)
# dinsity plot
sns.distplot(fitted_data , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "RATE" , color ='green')

''' I would prefer to do BoxCox transformation because after doing boxcox transformation
    Q-Q plot shows the data is now normally distributed as compare to before transformation'''
    

'''-----Normalization----'''

# Normalization / Min-Max Scaler is prefered for dummy variables
# Standardizarion -  is prefred when data have less outlier or have no outliers
# Robust Scalling - is used whern data have more outliers

'''Quantity - It has extreme outlier - Robust Scalling'''


from sklearn.preprocessing import RobustScaler

robust_model = RobustScaler()

df_robust = robust_model.fit_transform(data[['Quantity']])

dataset_robust = pd.DataFrame(df_robust)
res_robust = dataset_robust.describe()

'''Rate - Standardization'''

from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()

df = scaler.fit_transform(dataset[['Rate']])

dataset = pd.DataFrame(df)
res = dataset.describe()


