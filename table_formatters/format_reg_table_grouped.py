import pathlib
import pandas as pd

root = pathlib.Path.cwd()

def format_regression_table_grouped(df):
    # List to store rows for the new dataframe
    rows = []
    
    # Define groups of control variables
    groups = {
        "Demographics": ["Age", "Age Squared", "Female (1  Yes 0  No)"],
        "Marital Status and Schooling": ["Divorced", "Married", "Other", "Unmarried", "Widow/Widower", "Literate", 
                                         "Post primary schooling", "Post-secondary and university", "Primary school"]
    }
    
    # Identify the row index for "R-squared" to separate controls and summary stats
    r_squared_idx = df[df.iloc[:, 0] == '"R-squared"'].index[0]
    
    # Iterate over the dataframe by two rows (coefficient and its standard error)
    for i in range(0, df.shape[0], 2):
        # If the row is for the coefficient of interest or summary stats, keep the value
        if i == 2 or i >= r_squared_idx:
            rows.append(df.iloc[i])
        # For control variables, handle the groups
        else:
            variable_name = df.iloc[i, 0].replace('"', '')
            is_grouped = False
            for group_name, group_vars in groups.items():
                if variable_name in group_vars:
                    is_grouped = True
                    # If this is the first variable in the group, add the group name
                    if variable_name == group_vars[0]:
                        new_row = pd.Series([group_name] + ["X"] * (df.shape[1]-1))
                        rows.append(new_row)
                    break
            # If variable is not part of any group, just add it
            if not is_grouped:
                new_row = df.iloc[i].copy()
                new_row[1:] = new_row[1:].where(new_row[1:].str.contains("\*|[\d]") & ~new_row[1:].str.contains("b/se"), "")
                new_row[1:] = new_row[1:].where(new_row[1:] == "", "X")
                rows.append(new_row)
    
    # Concatenate rows to form the new dataframe
    formatted_df = pd.concat(rows, axis=1).T
    
    return formatted_df

# Update the main function to use the grouped formatting function
def csv_to_latex_table_grouped(filepath):
    # Read the csv content
    with open(filepath, 'r') as infile:
        csv_content = infile.read()

    # Use pandas to parse the CSV content
    df = pd.read_csv(filepath)
    
    # Remove the '=' from each cell
    df = df.applymap(lambda x: str(x).replace('=', '') if isinstance(x, str) else x)
    
    # Format the dataframe
    formatted_df = format_regression_table_grouped(df)
    
    # Convert the dataframe to LaTeX table format
    latex_table = formatted_df.to_latex(index=False, escape=False, caption="Regression Results", label="tab:regression_results")
    
    return latex_table

# Use the function with the file path directly
filepath = root / 'results/regressions/electricity_job_indirect_regression.csv'
latex_output_corrected = csv_to_latex_table_grouped(filepath)
print(latex_output_corrected)