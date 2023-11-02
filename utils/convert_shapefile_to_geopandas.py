import geopandas as gpd

# Path to your shapefile
shp_file_path = "data/maps/Swedish_parishes_1926.shp"

# Read the shapefile
gdf = gpd.read_file(shp_file_path)

# Convert to GeoJSON
gdf.to_file("data/maps/Swedish_parishes_1926.geojson", driver='GeoJSON')

# read in "data/power-stations/power-stations.xlsx"
import pandas as pd
df = pd.read_excel("data/power-stations/power-stations.xlsx")

# count unique items in the column "source_final"
df["source_final"].value_counts()