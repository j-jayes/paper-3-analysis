# what do we want to do?

# we have more parishes than we should. we need to check whether the repeated parishes are haveing an impact on the results

import pandas as pd
import pathlib
import statsmodels.api as sm

power_stations_df = pd.read_excel(pathlib.Path('data/first-stage/parish-level-power-station-data-vf-copy.xlsx'))

# arrange power_stations_df by treated in descending order and total_power_transmitted in descending order
power_stations_df = power_stations_df.sort_values(by=['treated', 'total_power_transmitted'], ascending=False)

power_stations_df.head(20)

# regress total_power_transmitted treated area population_1900 if distance_to_line < 300

# subset the data to include only observations where distance_to_line < 300
subset_df = power_stations_df[power_stations_df['distance_to_line'] < 250]

# drop na from subset_df
subset_df = subset_df.dropna()

# define the dependent variable and independent variables
y = subset_df['total_power_transmitted']
X = subset_df[['treated', 'area', 'population_1900']]

# add a constant to the independent variables
X = sm.add_constant(X)

# fit the linear regression model
model = sm.OLS(y, X).fit()

# print the regression results
print(model.summary())


