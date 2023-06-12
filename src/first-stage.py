import pandas as pd
import geopandas as gpd
from shapely.geometry import Point, LineString
from statsmodels.formula.api import ols

# Reading Excel Sheet
power_stations_df = pd.read_excel('path_to_power_stations_data.xlsx')

# Reading shapefile
parishes = gpd.read_file('path_to_parishes_shapefile.shp')
