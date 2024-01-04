import pandas as pd
import numpy as np
import scipy.stats as stats

# Step 1: Read the data from the Excel file
data = pd.read_excel("data/balance-tests/filtered_data_with_distances_balanced.xlsx")

# Make unbalanced sample tables
data = pd.read_excel("data/balance-tests/filtered_data_with_distances.xlsx")

# Step 2: Filter the data for treated and control groups for each year
treated_1890 = data[(data["treated"] == 1) & (data["year"] == 1890)]
control_1890 = data[(data["treated"] == 0) & (data["year"] == 1890)]
treated_1900 = data[(data["treated"] == 1) & (data["year"] == 1900)]
control_1900 = data[(data["treated"] == 0) & (data["year"] == 1900)]

# Step 3: Calculate mean and standard deviation for each variable and group
variables = ["shc1", "shc2", "shc3", "shc4", "shc5", "shc6", "shc7", "llabforce"]

means_1890_treated = treated_1890[variables].apply(np.nanmean)
stds_1890_treated = treated_1890[variables].std()
means_1890_control = control_1890[variables].apply(np.nanmean)
stds_1890_control = control_1890[variables].std()

means_1900_treated = treated_1900[variables].apply(np.nanmean)
stds_1900_treated = treated_1900[variables].std()
means_1900_control = control_1900[variables].apply(np.nanmean)
stds_1900_control = control_1900[variables].std()

# Step 4: Perform t-tests for each variable and year
ttest_1890 = pd.DataFrame(index=variables, columns=["Mean (Treated)", "Mean (Control)", "Std (Treated)", "Std (Control)", "Difference", "p-value"])
ttest_1900 = pd.DataFrame(index=variables, columns=["Mean (Treated)", "Mean (Control)", "Std (Treated)", "Std (Control)", "Difference", "p-value"])

for variable in variables:
    ttest_1890.loc[variable, "Mean (Treated)"] = means_1890_treated[variable]
    ttest_1890.loc[variable, "Mean (Control)"] = means_1890_control[variable]
    ttest_1890.loc[variable, "Std (Treated)"] = stds_1890_treated[variable]
    ttest_1890.loc[variable, "Std (Control)"] = stds_1890_control[variable]
    ttest_1890.loc[variable, "Difference"] = means_1890_treated[variable] - means_1890_control[variable], 
    ttest_1890.loc[variable, "p-value"] = stats.ttest_ind(
        treated_1890[variable], control_1890[variable], nan_policy='omit'
    )

    ttest_1900.loc[variable, "Mean (Treated)"] = means_1900_treated[variable]
    ttest_1900.loc[variable, "Mean (Control)"] = means_1900_control[variable]
    ttest_1900.loc[variable, "Std (Treated)"] = stds_1900_treated[variable]
    ttest_1900.loc[variable, "Std (Control)"] = stds_1900_control[variable]
    ttest_1900.loc[variable, "Difference"] = means_1900_treated[variable] - means_1900_control[variable], , 
    ttest_1900.loc[variable, "p-value"] = stats.ttest_ind(
        treated_1900[variable], control_1900[variable], nan_policy='omit'
    )



# Step 5: Format the output as LaTeX tables
shc_titles = {
    "shc1": "Elite",
    "shc2": "White collar",
    "shc3": "Foremen",
    "shc4": "Medium-skilled workers",
    "shc5": "Farmers and fishermen",
    "shc6": "Low-skilled workers",
    "shc7": "Unskilled workers",
    "llabforce": "Labour force"
}

table_1890 = ttest_1890.applymap(lambda x: f"{x:.2f}")
table_1890.index = table_1890.index.map(shc_titles)
table_1900 = ttest_1900.applymap(lambda x: f"{x:.2f}")
table_1900.index = table_1900.index.map(shc_titles)

# Step 6: Add significance asterisks to the p-values
table_1890["p-value"] = table_1890["p-value"].apply(lambda x: f"{float(x):.3f}" + ("*" if float(x) < 0.05 else "") if isinstance(x, (int, float)) else x)
table_1900["p-value"] = table_1900["p-value"].apply(lambda x: f"{float(x):.3f}" + ("*" if float(x) < 0.05 else "") if isinstance(x, (int, float)) else x)

# Step 7: Print the tables
print("1890:")
print(table_1890.to_latex())
print("\n1900:")
print(table_1900.to_latex())