'''Auto EDA - Before Pre-Processing'''

import pandas as pd
data = pd.read_csv(r"C:\Users\SONIYA\Desktop\PROJECT 2\Dataset\Dataset after pre_processing.csv")

# Sweetviz
import sweetviz as sv

s = sv.analyze(data)
s.show_html()


# Autoviz
from autoviz.AutoViz_Class import AutoViz_Class

av = AutoViz_Class()
a = av.AutoViz("C:\Users\SONIYA\Desktop\PROJECT 2\Dataset\Dataset after pre_processing.csv", chart_format = 'html')

import os
os.getcwd()

# D-Tale
import dtale

d = dtale.show(data)
d.open_browser()
d.to_file("output.html")


# Pandas Profiling
import pandas as pd
from pandas_profiling import ProfileReport 

p = ProfileReport(data)
p.show_browser()
p.to_file("output.html")

import os
os.getcwd()

# Dataprep
from dataprep.eda import create_report

report = create_report(data, title = 'My Report')

report.show_browser()

report.to_file("output1.html")

report.show_notebook()


import pandas as pd

from sqlalchemy import create_engine

engine = create_engine("mysql+pymysql://{user}:{pw}@localhost/{db}"
                       .format(user = "root",
                               pw = "123456",
                               db = "steel_rod"))

sql = "SELECT * FROM dataset;"
dataset = pd.read_sql_query(sql, engine)

# Yeo-Johnson Transformation

from feature_engine import transformation
tf = transformation.YeoJohnsonTransformer(variables = 'Quantity_Transformation') 
dataset = tf.fit_transform(dataset)

stats.probplot(dataset.Quantity , dist = "norm" , plot = pylab)
stats.probplot(dataset.Quantity_Transformation, dist = "norm" , plot = pylab)

fix , ax = plt.subplots(1 , 2)
sns.distplot(dataset.Quantity , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "Non-Normal" , color = 'green' , ax = ax[0])
sns.distplot(dataset.Quantity_Transformation , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "Normal" , color = 'green' , ax = ax[1] )

sns.distplot(dataset.Quantity_Transformation , axlabel = 'Quantity' , color = 'purple' , hist_kws = {"edgecolor" : 'black'})

sns.distplot(dataset.box_cox_Rate, axlabel = 'Rate', color = 'purple', hist_kws = {"edgecolor" : 'black'})
sns.distplot(dataset.Rate, axlabel = 'Rate', color = 'purple', hist_kws = {"edgecolor" : 'black'})
import numpy as np
Rate = np.log(data.Rate)

#Q-Q Plot
stats.probplot(dataset.Rate, dist = "norm" , plot = pylab)
stats.probplot(np.log(dataset.Rate) , dist = "norm" , plot = pylab)
# dinsity plot
sns.distplot(Rate , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "RATE" , color ='green')

#--=Box Cox Transformation
fitted_data, fitted_lamda = stats.boxcox(dataset.Rate)

#Q-Q Plot
stats.probplot(fitted_data , dist = "norm" , plot = pylab)
# dinsity plot
sns.distplot(dataset.box_cox_Rate , hist = False , kde = True,
             kde_kws = {'shade' : True , 'linewidth' : 2},
             label = "RATE" , color ='green')

'''Auto EDA - After Pre-Processing'''


# Sweetviz
import sweetviz as sv

s = sv.analyze(dataset)
s.show_html()


# Autoviz
from autoviz.AutoViz_Class import AutoViz_Class

av = AutoViz_Class()
a = av.AutoViz(dataset, chart_format = 'html')

import os
os.getcwd()

# D-Tale
import dtale

d = dtale.show(dataset)
d.open_browser()
d.to_file("output.html")


# Pandas Profiling
import pandas as pd
from pandas_profiling import ProfileReport 

p = ProfileReport(dataset)
p.show_browser()
p.to_file("output.html")

import os
os.getcwd()

# Dataprep
from dataprep.eda import create_report

report = create_report(dataset, title = 'My Report')

report.show_browser()

report.to_file("output1.html")

report.show_notebook()