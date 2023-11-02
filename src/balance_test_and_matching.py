# Purpose
# balance tests
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import NearestNeighbors
import numpy as np


new_df = pd.read_csv('data/balance-tests/balance_tests_1900_with_outcomes_250.csv')

numerical_columns = ['shc1', 'shc2', 'shc3', 'shc4', 'shc5', 'shc6', 'shc7', 'llabforce']


# Prepare the data for the new dataset
X_new = new_df[numerical_columns]  # Features for propensity score
y_new = new_df['treated']  # Treatment indicator

# Check for missing or NaN values in the feature columns
missing_values_count_new = X_new.isna().sum()
missing_values_count_new

# Calculate the mean of each variable for the treatment and control groups in the new dataset
means_treatment_new = new_df[new_df['treated'] == 1][numerical_columns].mean()
means_control_new = new_df[new_df['treated'] == 0][numerical_columns].mean()

# Impute missing values with the calculated means
for col in numerical_columns:
    new_df.loc[(new_df['treated'] == 1) & (new_df[col].isna()), col] = means_treatment_new[col]
    new_df.loc[(new_df['treated'] == 0) & (new_df[col].isna()), col] = means_control_new[col]

# Check if there are any missing values left
new_df[numerical_columns].isna().sum()


# Update the feature matrix X_new with the imputed values
X_new = new_df[numerical_columns]

logistic_model = LogisticRegression()

# Re-fit the logistic regression model to estimate new propensity scores
logistic_model.fit(X_new, y_new)

# Update propensity scores in the new DataFrame
new_df['propensity_score'] = logistic_model.predict_proba(X_new)[:, 1]

# Show the first few rows of the DataFrame with the updated propensity scores
new_df.head()[['shc1', 'shc2', 'shc3', 'shc4', 'shc5', 'shc6', 'shc7', 'llabforce', 'treated', 'propensity_score']]

# Separate the data into treatment and control groups in the new dataset
treatment_df_new = new_df[new_df['treated'] == 1]
control_df_new = new_df[new_df['treated'] == 0]

nn = NearestNeighbors(n_neighbors=1)

# Fit nearest neighbors model on control group in the new dataset
nn.fit(np.array(control_df_new['propensity_score']).reshape(-1, 1))

# Find nearest neighbors for treatment group in the new dataset
distances_new, indices_new = nn.kneighbors(np.array(treatment_df_new['propensity_score']).reshape(-1, 1))

# Create a DataFrame for matched pairs in the new dataset
matched_pairs_new = pd.DataFrame({
    'treated_index': treatment_df_new.index,
    'control_index': control_df_new.iloc[indices_new.flatten()].index,
    'distance': distances_new.flatten()
})

# Combine the matched pairs into a single DataFrame in the new dataset
matched_df_new = pd.concat([
    treatment_df_new.loc[matched_pairs_new['treated_index']].reset_index(drop=True),
    control_df_new.loc[matched_pairs_new['control_index']].reset_index(drop=True)
], keys=['treated', 'control']).reset_index().drop('level_1', axis=1).rename(columns={'level_0': 'group'})

from scipy.stats import ttest_ind

# Perform t-tests for the outcomes 'total_power' and 'total_connections' in the new dataset
matched_treatment_df_new = matched_df_new[matched_df_new['group'] == 'treated']
matched_control_df_new = matched_df_new[matched_df_new['group'] == 'control']
ttest_results_power_new = ttest_ind(matched_treatment_df_new['total_power'], matched_control_df_new['total_power'])
ttest_results_connections_new = ttest_ind(matched_treatment_df_new['total_connections'], matched_control_df_new['total_connections'])

ttest_results_power_new, ttest_results_connections_new



# List of variables to compare between the treatment and control groups
compare_columns = ['shc1', 'shc2', 'shc3', 'shc4', 'shc5', 'shc6', 'shc7', 'llabforce', 'total_power', 'total_connections']

# Initialize lists to store the mean values and p-values
mean_treatment = []
mean_control = []
p_values = []

# Calculate the mean values and p-values for each variable
for col in compare_columns:
    mean_treatment.append(matched_treatment_df_new[col].mean())
    mean_control.append(matched_control_df_new[col].mean())
    _, p_value = ttest_ind(matched_treatment_df_new[col], matched_control_df_new[col])
    p_values.append(p_value)

# Create the summary table
summary_table = pd.DataFrame({
    'Variable': compare_columns,
    'Mean (Treatment Group)': mean_treatment,
    'Mean (Control Group)': mean_control,
    'P-Value': p_values
})

summary_table


import matplotlib.pyplot as plt

# Define the data for the plot
propensity_before_treatment = new_df[new_df['treated'] == 1]['propensity_score']
propensity_before_control = new_df[new_df['treated'] == 0]['propensity_score']
propensity_after_treatment = matched_df_new[matched_df_new['group'] == 'treated']['propensity_score']
propensity_after_control = matched_df_new[matched_df_new['group'] == 'control']['propensity_score']

# Create the plot
fig, axes = plt.subplots(1, 2, figsize=(14, 6), sharey=True)
fig.suptitle('Propensity Score Matching Visualization')

# Before Matching
axes[0].scatter(propensity_before_treatment, [0] * len(propensity_before_treatment), label='Treatment (Before)', alpha=0.6)
axes[0].scatter(propensity_before_control, [1] * len(propensity_before_control), label='Control (Before)', alpha=0.6)
axes[0].set_title('Before Matching')
axes[0].set_yticks([0, 1])
axes[0].set_yticklabels(['Treatment', 'Control'])
axes[0].set_xlabel('Propensity Score')
axes[0].legend()

# After Matching
axes[1].scatter(propensity_after_treatment, [0] * len(propensity_after_treatment), label='Treatment (After)', alpha=0.6)
axes[1].scatter(propensity_after_control, [1] * len(propensity_after_control), label='Control (After)', alpha=0.6)
axes[1].set_title('After Matching')
axes[1].set_yticks([0, 1])
axes[1].set_yticklabels(['Treatment', 'Control'])
axes[1].set_xlabel('Propensity Score')
axes[1].legend()

# Show the plot
plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()


## Original table

# Initialize lists to store the mean values and p-values for the unmatched data
mean_unmatched_treatment = []
mean_unmatched_control = []
p_values_unmatched = []

# Calculate the mean values and p-values for each variable in the unmatched data
for col in compare_columns:
    mean_unmatched_treatment.append(new_df[new_df['treated'] == 1][col].mean())
    mean_unmatched_control.append(new_df[new_df['treated'] == 0][col].mean())
    _, p_value_unmatched = ttest_ind(new_df[new_df['treated'] == 1][col], new_df[new_df['treated'] == 0][col])
    p_values_unmatched.append(p_value_unmatched)

# Create the summary table for the unmatched data
summary_table_unmatched = pd.DataFrame({
    'Variable': compare_columns,
    'Mean (Treatment Group)': mean_unmatched_treatment,
    'Mean (Control Group)': mean_unmatched_control,
    'P-Value': p_values_unmatched
})

summary_table_unmatched