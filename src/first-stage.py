import pandas as pd
import geopandas as gpd
from shapely.geometry import Point, LineString
from statsmodels.formula.api import ols
import pathlib
import openpyxl

# Reading Excel Sheet
power_stations_path = pathlib.Path('data/power-stations/power-stations.xlsx')
power_stations_df = pd.read_excel(power_stations_path)

# Reading shapefile
parishes_path = pathlib.Path('data/maps/Swedish_parishes_1926.shp')
parishes = gpd.read_file(parishes_path)

# Create a new GeoDataFrame
geometry = [Point(xy) for xy in zip(power_stations_df['longitude'], power_stations_df['latitude'])]
geo_power_stations = gpd.GeoDataFrame(power_stations_df, crs='EPSG:4326', geometry=geometry)

# Ensure both GeoDataFrames use the same Coordinate Reference System
parishes = parishes.to_crs('EPSG:4326')

# Spatial join
stations_with_parish = gpd.sjoin(geo_power_stations, parishes, how='left', op='within')

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
distances = [100, 150, 200]  # replace with your distances in km
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

# Add this data to "parishes" and "control_parishes"
parishes = parishes.merge(total_power, on='ref_code', how='left')
for distance in distances:
    control_parishes[distance] = control_parishes[distance].merge(total_power, on='ref_code', how='left')

# in control_parishes, replace NaN with 0 in amount_final
for distance in distances:
    control_parishes[distance]['amount_final'] = control_parishes[distance]['amount_final'].fillna(0)

# Find all parishes that touch a treated parish
touching_parishes = gpd.overlay(parishes, treated_parishes_geometry, how='intersection', keep_geom_type=False)
# drop ref_code_2 and rename ref_code_1 to ref_code
touching_parishes = touching_parishes.drop(columns=['ref_code_2']).rename(columns={'ref_code_1': 'ref_code'})

# Exclude these parishes from control groups
for distance in distances:
    control_parishes[distance] = control_parishes[distance][~control_parishes[distance]['ref_code'].isin(touching_parishes['ref_code'])]


# Visualize:
import matplotlib.pyplot as plt

# Create a DataFrame to store results
results_df = pd.DataFrame(columns=['Distance', 'Coefficient', 'CI_lower', 'CI_upper', 'P-value', 'F-statistic'])

for distance in distances:
    data = pd.concat([parishes, control_parishes[distance]])
    model = ols("amount_final ~ treatment", data=data).fit()
    coef = model.params['treatment[T.treated]']
    ci_lower, ci_upper = model.conf_int().loc['treatment[T.treated]']
    p_value = model.pvalues['treatment[T.treated]']
    f_stat = model.fvalue
    new_row = pd.DataFrame({'Distance': [distance], 'Coefficient': [coef], 'CI_lower': [ci_lower], 'CI_upper': [ci_upper], 'P-value': [p_value], 'F-statistic': [f_stat]})
    results_df = pd.concat([results_df, new_row], ignore_index=True)


# Create plot
plt.figure(figsize=(10, 6))
plt.errorbar(x='Distance', y='Coefficient', yerr=[results_df['Coefficient'] - results_df['CI_lower'], results_df['CI_upper'] - results_df['Coefficient']], data=results_df, fmt='o')
# add x-tick labels for distances
plt.xticks(np.arange(len(distances)), distances)
# draw a line at y=0
plt.axhline(0, color='black', linewidth=0.5, linestyle='dotted')

plt.xlabel('Control group distance from Western Line (km)')
plt.ylabel('Coefficient')
plt.title('Regression Coefficients and 95% Confidence Intervals')
plt.grid(True)
plt.show()


# Great, I am going to give you the whole script, and I want you to refactor it so that the parameters like distances and whether or not to exclude the parishes touching 