import pandas as pd

df = pd.read_parquet("./data/census/census_1930_excl_unbalanced_controls.parquet")

# Print columns containing "yrke"

# Count the most common occupations
overall_top_occupations = df['yrke.x'].value_counts().head(10)

# For electricity_job_direct
direct_top_occupations = df[df['electricity_job_direct'] == 1]['yrke.x'].value_counts().head(10)

# For electricity_job_indirect
indirect_top_occupations = df[df['electricity_job_indirect'] == 1]['yrke.x'].value_counts().head(10)

def calculate_gender_share(occupation_list, df):
    gender_share = {}
    for occupation in occupation_list:
        total = df[df['yrke.x'] == occupation].shape[0]
        women_count = df[(df['yrke.x'] == occupation) & (df['female'] == 1)].shape[0]
        men_count = total - women_count
        gender_share[occupation] = {'Women': women_count / total, 'Men': men_count / total}
    return gender_share

# Overall gender share
overall_gender_share = calculate_gender_share(overall_top_occupations.index, df)

# Direct jobs gender share
direct_gender_share = calculate_gender_share(direct_top_occupations.index, df)

# Indirect jobs gender share
indirect_gender_share = calculate_gender_share(indirect_top_occupations.index, df)

# Combining the data into a single dataframe
final_df = pd.DataFrame({
    'Occupation': overall_top_occupations.index,
    'Overall Count': overall_top_occupations.values,
    'Overall Women Share': [overall_gender_share[occ]['Women'] for occ in overall_top_occupations.index],
    'Overall Men Share': [overall_gender_share[occ]['Men'] for occ in overall_top_occupations.index],
    'Direct Count': direct_top_occupations.reindex(overall_top_occupations.index).fillna(0),
    'Direct Women Share': [direct_gender_share.get(occ, {'Women': 0})['Women'] for occ in overall_top_occupations.index],
    'Direct Men Share': [direct_gender_share.get(occ, {'Men': 0})['Men'] for occ in overall_top_occupations.index],
    'Indirect Count': indirect_top_occupations.reindex(overall_top_occupations.index).fillna(0),
    'Indirect Women Share': [indirect_gender_share.get(occ, {'Women': 0})['Women'] for occ in overall_top_occupations.index],
    'Indirect Men Share': [indirect_gender_share.get(occ, {'Men': 0})['Men'] for occ in overall_top_occupations.index]
})

final_df

# Save the dataframe to a csv file
final_df.to_csv("./data/summary-stats/07-income-calculations.csv", index=False)