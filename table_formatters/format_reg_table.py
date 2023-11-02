import pathlib
import pandas as pd

root = pathlib.Path.cwd()

def format_regression_table_final_corrected(df):
    # List to store rows for the new dataframe
    rows = []
    
    # Identify the row index for "R-squared" to separate controls and summary stats
    r_squared_idx = df[df.iloc[:, 0] == '"R-squared"'].index[0]
    
    # Iterate over the dataframe by two rows (coefficient and its standard error)
    for i in range(0, df.shape[0], 2):
        # If the row is for the coefficient of interest or summary stats, keep the value
        if i == 2 or i >= r_squared_idx:
            rows.append(df.iloc[i])
        # For control variables, keep the variable name and replace coefficients with 'X' (and blank otherwise)
        else:
            new_row = df.iloc[i].copy()
            new_row[1:] = new_row[1:].where(new_row[1:].str.contains("\*|[\d]") & ~new_row[1:].str.contains("b/se"), "")
            new_row[1:] = new_row[1:].where(new_row[1:] == "", "X")
            rows.append(new_row)
    
    # Concatenate rows to form the new dataframe
    formatted_df = pd.concat(rows, axis=1).T
    
    # Update the variable names to remove quotes and standardize
    formatted_df = formatted_df.applymap(lambda x: x.replace('"', '') if isinstance(x, str) else x)
    
    # Reorder the summary statistics rows based on the provided order
    order = ["R-squared", "Observations", "F-stat", "Mean Dependent Var"]
    summary_stats = formatted_df[formatted_df.iloc[:, 0].isin(order)]
    summary_stats = summary_stats.set_index(summary_stats.iloc[:, 0]).reindex(order).reset_index(drop=True)
    
    # Replace the old summary stats with the reordered ones
    formatted_df = formatted_df[~formatted_df.iloc[:, 0].isin(order)]
    formatted_df = pd.concat([formatted_df, summary_stats], axis=0)
    
    return formatted_df

# Update the main function to use the corrected formatting function
def csv_to_latex_table_final_corrected(filepath):
    # Read the csv content
    with open(filepath, 'r') as infile:
        csv_content = infile.read()

    # Use pandas to parse the CSV content
    df = pd.read_csv(filepath)
    
    # Remove the '=' from each cell
    df = df.applymap(lambda x: str(x).replace('=', '') if isinstance(x, str) else x)
    
    # Format the dataframe
    formatted_df = format_regression_table_final_corrected(df)
    
    # Convert the dataframe to LaTeX table format
    latex_table = formatted_df.to_latex(index=False, escape=False, caption="Regression Results", label="tab:regression_results")
    
    return latex_table



# Use the function with the file path directly
filepath = root / 'results/regressions/employed_regression.csv'
latex_output_corrected = csv_to_latex_table_final_corrected(filepath)
print(latex_output_corrected)
