def run_analysis(distances, exclude_touching, source_type, outcome_var, include_area):
    """
    Run an analysis based on given parameters.

    Parameters
    ----------
    distances : list of int
        List of distances in km to consider for control groups.
    exclude_touching : bool
        Whether to exclude parishes touching the treatment group.
    source_type : str or None
        Type of power source to consider. Can be 'water', 'transmitted', or None.
    outcome_var : str
        Outcome variable for regression. Can be 'amount_final' or 'num_power_stations'.
    include_area : bool
        Whether to include parish area as a control variable.

    Returns
    -------
    results_df : DataFrame
        DataFrame containing the regression results.
    """

    import pandas as pd
    import geopandas as gpd
    from shapely.geometry import Point, LineString
    from statsmodels.formula.api import ols
    import pathlib
    import openpyxl
    import os
    import numpy as np
    import matplotlib.pyplot as plt
    
    # Reading Excel Sheet
    power_stations_path = pathlib.Path('data/power-stations/power-stations.xlsx')
    power_stations_df = pd.read_excel(power_stations_path)

    # Filter based on source type
    if source_type is not None:
        power_stations_df = power_stations_df[power_stations_df['source_final'] == source_type]

    # Reading shapefile
    parishes_path = pathlib.Path('data/maps/Swedish_parishes_1926.shp')
    parishes = gpd.read_file(parishes_path)

    # Create a new GeoDataFrame
    geometry = [Point(xy) for xy in zip(power_stations_df['longitude'], power_stations_df['latitude'])]
    geo_power_stations = gpd.GeoDataFrame(power_stations_df, crs='EPSG:4326', geometry=geometry)

    # Ensure both GeoDataFrames use the same Coordinate Reference System
    parishes = parishes.to_crs('EPSG:4326')

    # Convert CRS to UTM zone 33N
    parishes = parishes.to_crs('EPSG:32633')
    # Calculate area in square kilometers and add as a new column
    parishes['area_sqkm'] = parishes['geometry'].area / 10**6
    # Convert CRS back to latitude and longitude
    parishes = parishes.to_crs('EPSG:4326')


    # Spatial join
    stations_with_parish = gpd.sjoin(geo_power_stations, parishes, how='left', op='within')
    num_power_stations = stations_with_parish.groupby('ref_code').size().reset_index(name='num_power_stations')


    # olidan coords: 12.272571287279908, 58.27550603306433
    # älvkarleby coords: 17.443262677788724, 60.5633613884066
    # Create points
    station1_coords = (12.272571287279908, 58.27550603306433)
    station2_coords = (17.443262677788724, 60.5633613884066)

    # Create line
    line = LineString([station1_coords, station2_coords])

    # Create a GeoDataFrame from the line
    line_gdf = gpd.GeoDataFrame(geometry=[line], crs='EPSG:4326')

    # Create buffers
    buffer_gdfs = [gpd.GeoDataFrame(geometry=gpd.GeoSeries(line_gdf.to_crs('EPSG:32633').buffer(distance*1000)), crs='EPSG:32633').to_crs('EPSG:4326') for distance in distances]

    control_parishes = {}

    for distance, buffer_gdf in zip(distances, buffer_gdfs):
        control_parishes[distance] = gpd.sjoin(parishes, buffer_gdf, how='inner', op='intersects')

    # read in treated parish list
    treated_parishes = pd.read_excel(pathlib.Path('data/parishes/treated_parishes.xlsx'))

    # create column called ref_code, by concatenating the "SE/" and variable parish_code, if there are 9 digits, add a 0 in front
    treated_parishes['ref_code'] = treated_parishes['parish_code'].apply(lambda x: 'SE/' + str(x).zfill(9))

    # select only parish_name, parish_name_lower and ref_code
    treated_parishes = treated_parishes[['parish_name', 'parish_name_lower', 'ref_code']]


    # treated_parishes = treated_parishes.to_crs(parishes.crs)
    parishes = parishes.merge(treated_parishes[['ref_code']], on='ref_code', how='left', indicator='treatment')
    parishes['treatment'] = parishes['treatment'].map({'both': 'treated', 'left_only': 'control'})

    # create an object called treated_parishes_geometry, which is a GeoDataFrame of the geometry of treated parishes
    treated_parishes_geometry = treated_parishes.merge(parishes[['ref_code', 'geometry']], on='ref_code', how='left')
    # turn this into a GeoDataFrame
    treated_parishes_geometry = gpd.GeoDataFrame(treated_parishes_geometry, crs='EPSG:4326', geometry='geometry')

    # Calculate total power in each parish
    total_power = stations_with_parish.groupby('ref_code')['amount_final'].sum().reset_index()

    # Add these data to "parishes" and "control_parishes"
    parishes = parishes.merge(total_power, on='ref_code', how='left')
    parishes = parishes.merge(num_power_stations, on='ref_code', how='left')

    for distance in distances:
        control_parishes[distance] = control_parishes[distance].merge(total_power, on='ref_code', how='left')
        control_parishes[distance] = control_parishes[distance].merge(num_power_stations, on='ref_code', how='left')


    # Replace NaN with 0 in the outcome variables
    for distance in distances:
        control_parishes[distance]['amount_final'] = control_parishes[distance]['amount_final'].fillna(0)
        control_parishes[distance]['num_power_stations'] = control_parishes[distance]['num_power_stations'].fillna(0)
        control_parishes[distance]['area_sqkm'] = control_parishes[distance]['area_sqkm'].fillna(0)


    # in control parishes, generate treament column = 0
    for distance in distances:
        control_parishes[distance]['treatment'] = 0

    # Find all parishes that touch a treated parish
    if exclude_touching:
        touching_parishes = gpd.overlay(parishes, treated_parishes_geometry, how='intersection', keep_geom_type=False)
        # drop ref_code_2 and rename ref_code_1 to ref_code
        touching_parishes = touching_parishes.drop(columns=['ref_code_2']).rename(columns={'ref_code_1': 'ref_code'})

        # Exclude these parishes from control groups
        for distance in distances:
            control_parishes[distance] = control_parishes[distance][~control_parishes[distance]['ref_code'].isin(touching_parishes['ref_code'])]

    # Create a DataFrame to store results
    results_df = pd.DataFrame(columns=['Distance', 'Exclude_Touching', 'Source_Type', 'Outcome_Var', 'Coefficient', 'CI_lower', 'CI_upper', 'P-value', 'F-statistic'])

    parishes_with_treatment = parishes[parishes['treatment'] == 'treated']
    # code treatment as 1
    parishes_with_treatment['treatment'] = 1

    results_folder = pathlib.Path('results')
    results_folder.mkdir(exist_ok=True)  # create the results folder if it doesn't already exist

    for distance in distances:
        data = pd.concat([parishes_with_treatment, control_parishes[distance]])

        if include_area:
            model = ols(f"{outcome_var} ~ treatment + area_sqkm", data=data).fit()
        else:
            model = ols(f"{outcome_var} ~ treatment", data=data).fit()

        coef = model.params['treatment']
        ci_lower, ci_upper = model.conf_int().loc['treatment']
        p_value = model.pvalues['treatment']
        f_stat = model.fvalue
        new_row = pd.DataFrame({'Distance': [distance], 'Exclude_Touching': [exclude_touching], 'Source_Type': [source_type], 'Outcome_Var': [outcome_var], "Include area": [include_area], 'Coefficient': [coef], 'CI_lower': [ci_lower], 'CI_upper': [ci_upper], 'P-value': [p_value], 'F-statistic': [f_stat]})
        results_df = pd.concat([results_df, new_row], ignore_index=True)
        # Generate map
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


    # Save the coefficient plot and table

    plt.figure(figsize=(10, 6))
    plt.errorbar(x='Distance', y='Coefficient', yerr=[results_df['Coefficient'] - results_df['CI_lower'], results_df['CI_upper'] - results_df['Coefficient']], data=results_df, fmt='o')
    # plt.xticks(np.arange(len(distances)), distances)
    plt.axhline(0, color='black', linewidth=0.5, linestyle='dotted')
    plt.xlabel('Control group distance from Western Line (km)')
    plt.ylabel('Coefficient')
    plt.title('Regression Coefficients and 95% Confidence Intervals')
    plt.grid(True)
    plt.savefig(results_folder / 'coefficients_plot.png')  # save the plot as a .png file

    results_filename = results_folder / 'regression_results.xlsx'
    results_df.to_excel(results_filename, index=False)
    return results_df, results_filename

# Call function
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

all_results_df.to_excel("results/all_results.xlsx", index=False)

# Generate LaTeX table
latex_table = all_results_df.to_latex(index=False)

# Save to .tex file
with open("results/all_results.tex", "w") as f:
    f.write(latex_table)



# data = pd.concat([parishes_with_treatment, control_parishes[250]])
 # scatterplot with regression line. x-axis has area_sqkm, y-axis has num_power_stations
# import seaborn as sns
# plot = sns.regplot(x='area_sqkm', y='num_power_stations', data=data)

# display plot
# plt.show()