!pip install statsmodels stargazer

import statsmodels.formula.api as smf
from stargazer.stargazer import Stargazer

# Filter the data
df_filtered = df[df['distance_to_line'] < 300]

# Run the regressions
model1 = smf.ols('total_power ~ treated + area + population_1900', data=df_filtered).fit(cov_type='HC1')  # Robust standard errors
model2 = smf.ols('total_power_transmitted ~ treated + area + population_1900', data=df_filtered).fit(cov_type='HC1')  # Robust standard errors
model3 = smf.ols('total_power_generated ~ treated + area + population_1900', data=df_filtered).fit(cov_type='HC1')  # Robust standard errors

# Create the Stargazer object
stargazer = Stargazer([model1, model2, model3])

# Specify the title of the table
stargazer.title('Regression Results')

# Specify the names of the models
stargazer.custom_columns(['Total Power', 'Total Power Transmitted', 'Total Power Generated'], [1, 1, 1])

# Add the mean of the dependent variable
mean1 = round(df_filtered['total_power'].mean(), 2)
mean2 = round(df_filtered['total_power_transmitted'].mean(), 2)
mean3 = round(df_filtered['total_power_generated'].mean(), 2)

stargazer.add_custom_notes(['Mean of total power: {}'.format(mean1),
                            'Mean of total power transmitted: {}'.format(mean2),
                            'Mean of total power generated: {}'.format(mean3)])

# Generate and print the LaTeX code of the table
print(stargazer.render_latex())
