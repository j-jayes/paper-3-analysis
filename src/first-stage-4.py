import pandas as pd
import geopandas as gpd
from shapely.geometry import Point, LineString
from statsmodels.formula.api import ols
import pathlib
import openpyxl
import os
import numpy as np
import matplotlib.pyplot as plt
import itertools

def read_excel(file_path):
    """
    Function to read excel file and return a pandas dataframe
    """
    file_path = pathlib.Path(file_path)
    df = pd.read_excel(file_path)
    return df

def filter_by_source_type(df, source_type):
    """
    Function to filter power stations dataframe based on source type
    """
    if source_type is not None:
        df = df[df['source_final'] == source_type]
    return df

def read_shapefile(file_path):
    """
    Function to read shapefile and return a geopandas dataframe
    """
    file_path = pathlib.Path(file_path)
    gdf = gpd.read_file(file_path)
    return gdf

def create_geodataframe(df, long, lat):
    """
    Function to create a geopandas dataframe based on given pandas dataframe,
    longitude and latitude.
    """
    geometry = [Point(xy) for xy in zip(df[long], df[lat])]
    geo_df = gpd.GeoDataFrame(df, crs='EPSG:4326', geometry=geometry)
    return geo_df

def change_crs(df, crs):
    """
    Function to change the coordinate reference system of a geopandas dataframe
    """
    df = df.to_crs(crs)
    return df

def calculate_area(df, col_name):
    """
    Function to calculate area in square kilometers and add as a new column
    """
    df[col_name] = df['geometry'].area / 10**6
    return df

def merge_df(df1, df2, on, how='left'):
    """
    Function to merge two pandas dataframe on given columns
    """
    df = df1.merge(df2, on=on, how=how)
    return df

def spatial_join(df1, df2, how='left', op='within'):
    """
    Function to perform spatial join on two geopandas dataframe
    """
    df = gpd.sjoin(df1, df2, how=how, op=op)
    return df

def group_by(df, group_by_col, size_col):
    """
    Function to group dataframe by column and calculate size
    """
    df = df.groupby(group_by_col).size().reset_index(name=size_col)
    return df

# Part 3: Functions for generating regression models and handling results

def run_regression(outcome_var, include_area, include_population, parishes_with_treatment, control_parishes):
    """Run regression based on given parameters and data."""
    import pandas as pd
    from statsmodels.formula.api import ols

    # DataFrame to store results
    results_df = pd.DataFrame(columns=['Distance', 'Coefficient', 'CI_lower', 'CI_upper', 'P-value', 'F-statistic', 'n_observations', 'R-squared'])

    for distance in control_parishes.keys():
        data = pd.concat([parishes_with_treatment, control_parishes[distance]])

        if include_area and include_population:
            model = ols(f"{outcome_var} ~ treatment + area_sqkm + population_1930", data=data).fit()
        elif include_area:
            model = ols(f"{outcome_var} ~ treatment + area_sqkm", data=data).fit()
        elif include_population:
            model = ols(f"{outcome_var} ~ treatment + population_1930", data=data).fit()
        else:
            model = ols(f"{outcome_var} ~ treatment", data=data).fit()

        coef = model.params['treatment']
        ci_lower, ci_upper = model.conf_int().loc['treatment']
        p_value = model.pvalues['treatment']
        f_stat = model.fvalue
        n_observations = model.nobs
        r_squared = model.rsquared
        new_row = pd.DataFrame({'Distance': [distance], 'Coefficient': [coef], 'CI_lower': [ci_lower], 'CI_upper': [ci_upper], 'P-value': [p_value], 'F-statistic': [f_stat], 'n_observations': [n_observations], 'R-squared': [r_squared]})
        results_df = pd.concat([results_df, new_row], ignore_index=True)

    return results_df

def generate_plots_and_save_results(distances, results_df, parishes, parishes_with_treatment, control_parishes):
    """Generate plots based on the results and save them."""
    import matplotlib.pyplot as plt
    import pathlib

    results_folder = pathlib.Path('results')
    results_folder.mkdir(exist_ok=True)  # create the results folder if it doesn't already exist

    # Generate maps
    for distance in distances:
        fig, ax = plt.subplots(figsize=(10, 10))
        ax.set_aspect('equal')
        # plot parishes
        parishes.boundary.plot(ax=ax, color='black', linewidth=0.5)
        # plot control group
        control_parishes[distance].plot(ax=ax, color='blue', alpha=0.5)
        # plot treatment group
        parishes_with_treatment.plot(ax=ax, color='red', alpha=0.5)
        plt.title(f'Treatment and Control Groups (Control Distance {distance} km)')
        plt.axis('off')
        plt.savefig(results_folder / f'groups_map_{distance}km.png', bbox_inches='tight')
        plt.close()

    # Save the coefficient plot and table
    plt.figure(figsize=(10, 6))
    plt.errorbar(x='Distance', y='Coefficient', yerr=[results_df['Coefficient'] - results_df['CI_lower'], results_df['CI_upper'] - results_df['Coefficient']], data=results_df, fmt='o')
    plt.axhline(0, color='black', linewidth=0.5, linestyle='dotted')
    plt.title('Treatment Coefficients by Control Distance')
    plt.xlabel('Control Distance (km)')
    plt.ylabel('Treatment Coefficient')
    plt.grid()
    plt.savefig(results_folder / 'coefficients_plot.png', bbox_inches='tight')
    plt.close()

    # Save results as csv
    results_df.to_csv(results_folder / 'results.csv', index=False)

    return

def run_analysis(source_type=None):
    """Run the analysis."""
    # Data loading and preprocessing
    power_stations = read_excel('path/to/excel/file')
    power_stations = filter_by_source_type(power_stations, source_type)
    power_stations_geo = create_geodataframe(power_stations, 'longitude', 'latitude')

    parishes = read_shapefile('path/to/shapefile')
    parishes = change_crs(parishes, 'EPSG:32632')
    parishes = calculate_area(parishes, 'area_sqkm')

    combined_data = merge_df(parishes, power_stations_geo, on='station_name', how='right')

    # Create control and treatment groups
    parishes_with_treatment, control_parishes = create_treatment_and_control_groups(combined_data, power_stations_geo)

    # Run regression
    results_df = run_regression(outcome_var='log_income_1960', include_area=True, include_population=True, parishes_with_treatment=parishes_with_treatment, control_parishes=control_parishes)

    # Generate plots and save results
    generate_plots_and_save_results([10, 20, 30, 40, 50], results_df, parishes, parishes_with_treatment, control_parishes)

    return
