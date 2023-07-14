import pandas as pd
import geopandas as gpd
from shapely.geometry import Point, LineString
from statsmodels.formula.api import ols
import pathlib
import openpyxl
import os
import numpy as np
import matplotlib.pyplot as plt
import lxml

def read_data():
    power_stations_df = pd.read_excel(pathlib.Path('data/power-stations/power-stations.xlsx'))
    parishes = gpd.read_file(pathlib.Path('data/maps/Swedish_parishes_1926.shp'))
    treated_parishes = pd.read_excel(pathlib.Path('data/parishes/treated_parishes.xlsx'))
    return power_stations_df, parishes, treated_parishes

def filter_source_type(power_stations_df, source_type):
    if source_type is not None:
        power_stations_df = power_stations_df[power_stations_df['source_final'] == source_type]
    return power_stations_df

def prepare_geospatial_data(power_stations_df, parishes):
    geometry = [Point(xy) for xy in zip(power_stations_df['longitude'], power_stations_df['latitude'])]
    geo_power_stations = gpd.GeoDataFrame(power_stations_df, crs='EPSG:4326', geometry=geometry)
    parishes = parishes.to_crs('EPSG:4326').to_crs('EPSG:32633')
    parishes['area_sqkm'] = parishes['geometry'].area / 10**6
    parishes = parishes.to_crs('EPSG:4326')
    return geo_power_stations, parishes

def spatial_join(geo_power_stations, parishes):
    stations_with_parish = gpd.sjoin(geo_power_stations, parishes, how='left', op='within')
    num_power_stations = stations_with_parish.groupby('ref_code').size().reset_index(name='num_power_stations')
    return stations_with_parish, num_power_stations

def prepare_treated_parishes(treated_parishes, parishes):
    treated_parishes['ref_code'] = treated_parishes['parish_code'].apply(lambda x: 'SE/' + str(x).zfill(9))
    treated_parishes = treated_parishes[['parish_name', 'parish_name_lower', 'ref_code']]
    parishes = parishes.merge(treated_parishes[['ref_code']], on='ref_code', how='left', indicator='treatment')
    parishes['treatment'] = parishes['treatment'].map({'both': 'treated', 'left_only': 'control'})
    return treated_parishes, parishes

def calculate_total_power(stations_with_parish):
    total_power = stations_with_parish.groupby('ref_code')['amount_final'].sum().reset_index()
    return total_power

def add_data_to_parishes(parishes, total_power, num_power_stations):
    parishes = parishes.merge(total_power, on='ref_code', how='left')
    parishes = parishes.merge(num_power_stations, on='ref_code', how='left')
    parishes['amount_final'] = parishes['amount_final'].fillna(0)
    parishes['num_power_stations'] = parishes['num_power_stations'].fillna(0)
    parishes['area_sqkm'] = parishes['area_sqkm'].fillna(0)
    return parishes

def run_regression(data, outcome_var, include_area):
    if include_area:
        model = ols(f"{outcome_var} ~ treatment + area_sqkm", data=data).fit()
    else:
        model = ols(f"{outcome_var} ~ treatment", data=data).fit()
    return model

def run_analysis(distances, exclude_touching, source_type, outcome_var, include_area):
    power_stations_df, parishes, treated_parishes = read_data()
    power_stations_df = filter_source_type(power_stations_df, source_type)
    geo_power_stations, parishes = prepare_geospatial_data(power_stations_df, parishes)
    stations_with_parish, num_power_stations = spatial_join(geo_power_stations, parishes)
    treated_parishes, parishes = prepare_treated_parishes(treated_parishes, parishes)
    total_power = calculate_total_power(stations_with_parish)
    parishes = add_data_to_parishes(parishes, total_power, num_power_stations)
    
    # Add the regression model
    model = run_regression(parishes, outcome_var, include_area, )
    
    # Generate a filename
    filename = f'results/temp/analysis_{distances}_{exclude_touching}_{source_type}_{outcome_var}_{include_area}.xlsx'
    
    # Save the summary to a dataframe
    summary_df = pd.read_html(model.summary().tables[1].as_html(), header=0, index_col=0)[0]
    
    # Save the model summary to an Excel file
    summary_df.to_excel(filename)
    
    # Return the summary dataframe and filename
    return summary_df, filename


params = [
    ([100, 150, 200, 250], True, "transmitted", "num_power_stations", False),
    ([100, 150, 200, 250], False, "transmitted", "num_power_stations", False),
    ([100, 150, 200, 250], True, "transmitted", "num_power_stations", True),
    ([100, 150, 200, 250], False, "transmitted", "num_power_stations", True),
    ([100, 150, 200, 250], True, "water", "amount_final", False),
    ([100, 150, 200, 250], False, "water", "amount_final", False),
    ([100, 150, 200, 250], True, None, "amount_final", False),
    ([100, 150, 200, 250], False, None, "amount_final", False),
    # add more parameter combinations as needed
]

all_results = []

for param in params:
    distances, exclude_touching, source_type, outcome_var, include_area = param
    df, filename = run_analysis(distances, exclude_touching, source_type, outcome_var, include_area)
    df["Results File"] = filename
    all_results.append(df)

# Concatenate all results
all_results_df = pd.concat(all_results)

all_results_df.to_excel("results/all_results-refactor-test.xlsx", index=False)

# Generate LaTeX table
latex_table = all_results_df.to_latex(index=False)

# Save to .tex file
with open("results/all_results.tex", "w") as f:
    f.write(latex_table)


