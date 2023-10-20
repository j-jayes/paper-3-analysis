import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Load the data from the second tab of the Excel file
data = pd.read_excel(root / "data/parishes/union_membership_and_treated_groups_merged.xlsx", sheet_name=1)

# Group by 'parish_code' and 'type_of_organization' and sum the number of members for 1900, 1910, and 1930
grouped_data = data.groupby(['parish_code', 'type_of_organization']).agg({
    'n_members_1900': 'sum',
    'n_members_1910': 'sum',
    'n_members_1930': 'sum',
    'population_1900': 'first',
    'population_1910': 'first',
    'population_1930': 'first'
}).reset_index()

# instead, group by 'parish_code' and 'type_of_organization' and take an average of a 10 year window around 1900, 1910, and 1930


# Calculate union density for 1900, 1910, and 1930
grouped_data['union_density_1900'] = (grouped_data['n_members_1900'] / grouped_data['population_1900']) * 100
grouped_data['union_density_1910'] = (grouped_data['n_members_1910'] / grouped_data['population_1910']) * 100
grouped_data['union_density_1930'] = (grouped_data['n_members_1930'] / grouped_data['population_1930']) * 100

# Joining the grouped_data with original data to get 'treated', 'distance_to_line', and 'touching_treated'
merged_data = pd.merge(grouped_data, data[['parish_code', 'treated', 'distance_to_line']], on='parish_code', how='left').drop_duplicates()

# Group parishes into 'treated', 'control', and 'other' based on the conditions
conditions = [
    (merged_data['treated'] == 1),
    (merged_data['treated'] == 0) & (merged_data['distance_to_line'] < 250)
]
choices = ['treated', 'control']
merged_data['group'] = np.select(conditions, choices, default='other')

# Cap the union densities at 100% for all years
merged_data['union_density_1900'] = np.clip(merged_data['union_density_1900'], 0, 100)
merged_data['union_density_1910'] = np.clip(merged_data['union_density_1910'], 0, 100)
merged_data['union_density_1930'] = np.clip(merged_data['union_density_1930'], 0, 100)

merged_data

# Pivot the dataframe
df_pivot = merged_data.pivot_table(index='parish_code', columns='type_of_organization', 
                          values=['union_density_1900', 'union_density_1910', 'union_density_1930'])

# Reset the index
df_pivot.reset_index(inplace=True)

# Flatten the MultiIndex columns
df_pivot.columns = ['_'.join(col).strip() for col in df_pivot.columns.values]

# rename df_pivot to union_density
union_density = df_pivot

# replace NaN with zero for all variables
union_density = union_density.fillna(0)

# Define the column name mapping
column_mapping = {
    'union_density_1900_FACKF': 'popular_movement_density_1900_FACKF',
    'union_density_1900_FRIK': 'popular_movement_density_1900_FRIK',
    'union_density_1900_NYKT': 'popular_movement_density_1900_NYKT',
    'union_density_1900_PARTI': 'popular_movement_density_1900_PARTI',
    'union_density_1910_FACKF': 'popular_movement_density_1910_FACKF',
    'union_density_1910_FRIK': 'popular_movement_density_1910_FRIK',
    'union_density_1910_NYKT': 'popular_movement_density_1910_NYKT',
    'union_density_1910_PARTI': 'popular_movement_density_1910_PARTI',
    'union_density_1930_FACKF': 'popular_movement_density_1930_FACKF',
    'union_density_1930_FRIK': 'popular_movement_density_1930_FRIK',
    'union_density_1930_NYKT': 'popular_movement_density_1930_NYKT',
    'union_density_1930_PARTI': 'popular_movement_density_1930_PARTI'
}

# Rename the columns
union_density.rename(columns=column_mapping, inplace=True)

# save union density data to csv at root / "data/union_data/union_density.csv"
union_density.to_csv(root / "data/union-data/union_density.csv", index=False)