import pandas as pd

# Loading the dataset
file_path = 'data/balance-tests/filtered_data_with_distances.xlsx'
df = pd.read_excel(file_path)

# Display the first few rows of the dataframe to understand its structure
df.head()

# Filtering for years 1890 and 1900
df_filtered = df[df['year'].isin([1890, 1900])]

# Defining the treated group (excluding rows with touching_treated == 1)
treated_group = df_filtered[(df_filtered['treated'] == 1) & (df_filtered['touching_treated'] != 1)]

# Defining the control group (distance_to_line <= 300 and not in treated group)
control_group = df_filtered[(df_filtered['distance_to_line'] <= 300) & ~df_filtered.index.isin(treated_group.index)]

# Displaying the first few rows of each group for verification
treated_group.head(), control_group.head()

from scipy.stats import ttest_ind

# Variables for t-test
variables = ['shc1', 'shc2', 'shc3', 'shc4', 'shc5', 'shc6', 'shc7', 'llabforce']

# Performing t-tests for each variable
t_test_results = {}
for var in variables:
    # Extracting the relevant data from each group
    treated_data = treated_group[var].dropna()
    control_data = control_group[var].dropna()

    # Performing the t-test
    t_stat, p_value = ttest_ind(treated_data, control_data, equal_var=False)  # Welch's t-test
    t_test_results[var] = {'t-statistic': t_stat, 'p-value': p_value}

# pretty printing the results
from pprint import pprint

pprint(t_test_results)

# Separating the data for years 1890 and 1900
treated_1890 = treated_group[treated_group['year'] == 1890]
treated_1900 = treated_group[treated_group['year'] == 1900]
control_1890 = control_group[control_group['year'] == 1890]
control_1900 = control_group[control_group['year'] == 1900]

# Function to perform t-tests
def perform_t_tests(treated, control, variables):
    results = {}
    for var in variables:
        # Extracting the relevant data from each group
        treated_data = treated[var].dropna()
        control_data = control[var].dropna()

        # Performing the t-test
        t_stat, p_value = ttest_ind(treated_data, control_data, equal_var=False)  # Welch's t-test
        results[var] = {'t-statistic': t_stat, 'p-value': p_value}
    return results

# Performing t-tests for 1890 and 1900
t_test_results_1890 = perform_t_tests(treated_1890, control_1890, variables)
t_test_results_1900 = perform_t_tests(treated_1900, control_1900, variables)

# pretty printing the results
pprint(t_test_results_1890)
pprint(t_test_results_1900)

# In 1890, 'shc5' and 'shc6' show significant differences (p < 0.05) between the treated and control groups. In 1900, the significant differences are again observed for 'shc5' and 'shc6'. Other variables do not show significant differences in either year based on the p-value threshold of 0.05. 

# Function to iteratively balance the control group
def balance_groups(treated, control, variable, p_value_threshold=0.05):
    # Sorting the control group by the variable in descending order
    control_sorted = control.sort_values(by=variable, ascending=False)

    for i in range(len(control_sorted)):
        # Dropping the top 'i' entries from the control group
        adjusted_control = control_sorted.iloc[i:]

        # Performing the t-test
        treated_data = treated[variable].dropna()
        control_data = adjusted_control[variable].dropna()
        t_stat, p_value = ttest_ind(treated_data, control_data, equal_var=False)

        # Check if the p-value meets the threshold
        if p_value > p_value_threshold:
            return adjusted_control, i, p_value

    # If no solution found, return the original control group
    return control, None, None

# Balancing the groups for shc5
balanced_control_group, num_dropped, final_p_value = balance_groups(treated_group, control_group, 'shc5')

# Displaying the results
balanced_control_group.shape, num_dropped, final_p_value

# Separating the balanced control group data for years 1890 and 1900
balanced_control_1890 = balanced_control_group[balanced_control_group['year'] == 1890]
balanced_control_1900 = balanced_control_group[balanced_control_group['year'] == 1900]

# Performing t-tests for 1890 and 1900 with the balanced control group
t_test_results_balanced_1890 = perform_t_tests(treated_1890, balanced_control_1890, variables)
t_test_results_balanced_1900 = perform_t_tests(treated_1900, balanced_control_1900, variables)

# pretty printing the results
pprint(t_test_results_balanced_1890)
pprint(t_test_results_balanced_1900)

# Adjusting the function to allow dropping of lowest values
def balance_groups_shc6(treated, control, variable, p_value_threshold=0.05):
    # Check if mean of treated is higher than control
    if treated[variable].mean() > control[variable].mean():
        # Sort control group by the variable in ascending order (to drop the lowest values first)
        control_sorted = control.sort_values(by=variable, ascending=True)
    else:
        # Sort control group by the variable in descending order (to drop the highest values first)
        control_sorted = control.sort_values(by=variable, ascending=False)

    for i in range(len(control_sorted)):
        # Dropping the top 'i' entries from the control group
        adjusted_control = control_sorted.iloc[i:]

        # Performing the t-test
        treated_data = treated[variable].dropna()
        control_data = adjusted_control[variable].dropna()
        t_stat, p_value = ttest_ind(treated_data, control_data, equal_var=False)

        # Check if the p-value meets the threshold
        if p_value > p_value_threshold:
            return adjusted_control, i, p_value

    # If no solution found, return the original control group
    return control, None, None

# Balancing the groups for shc6
balanced_control_group_shc6, num_dropped_shc6, final_p_value_shc6 = balance_groups_shc6(treated_group, balanced_control_group, 'shc6')

# Displaying the results
balanced_control_group_shc6.shape, num_dropped_shc6, final_p_value_shc6

# Separating the balanced control group data for years 1890 and 1900 (adjusted for shc6)
balanced_control_group_shc6_1890 = balanced_control_group_shc6[balanced_control_group_shc6['year'] == 1890]
balanced_control_group_shc6_1900 = balanced_control_group_shc6[balanced_control_group_shc6['year'] == 1900]

# Performing t-tests for 1890 and 1900 with the control group balanced for shc6
t_test_results_balanced_shc6_1890 = perform_t_tests(treated_1890, balanced_control_group_shc6_1890, variables)
t_test_results_balanced_shc6_1900 = perform_t_tests(treated_1900, balanced_control_group_shc6_1900, variables)

# pretty printing the results
pprint(t_test_results_balanced_shc6_1890)
pprint(t_test_results_balanced_shc6_1900)

# Now we have a balanced control group and a treated group who match on shc1-shc7 and llabforce. 
# The t-tests show that the groups are not significantly different for any of the variables.

# We can concatenate the treated and balanced control groups to create a new dataframe with all the data
df_balanced = pd.concat([treated_group, balanced_control_group_shc6])

# Saving the dataframe to a new file
df_balanced.to_excel('data/balance-tests/filtered_data_with_distances_balanced.xlsx', index=False)

# Find the control parishes that were dropped
control_group[~control_group.index.isin(balanced_control_group_shc6.index)]

# Keep just their parish_code and parish_code_short without duplicates
control_group[~control_group.index.isin(balanced_control_group_shc6.index)][['parish_code', 'parish_code_short']].drop_duplicates()

# save this smaller dataframe to a new file
control_group[~control_group.index.isin(balanced_control_group_shc6.index)][['parish_code', 'parish_code_short']].drop_duplicates().to_excel('data/balance-tests/control_parishes_dropped.xlsx', index=False)
