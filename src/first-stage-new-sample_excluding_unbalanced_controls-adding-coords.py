import geopandas as gpd
import pandas as pd

def main():
    # Load the GeoJSON file
    geojson_file = 'data/maps/Swedish_parishes_1926.geojson'  # Replace with your GeoJSON file path
    swedish_parishes = gpd.read_file(geojson_file)

    # Convert to WGS 84 CRS
    swedish_parishes_wgs84 = swedish_parishes.to_crs(epsg=4326)

    # Calculate centroids
    swedish_parishes_wgs84['centroid'] = swedish_parishes_wgs84.geometry.centroid

    # Extract centroid coordinates called latitute and longitude
    swedish_parishes_wgs84['latitude'] = swedish_parishes_wgs84.centroid.y
    swedish_parishes_wgs84['longitude'] = swedish_parishes_wgs84.centroid.x

    # Load the Excel file
    excel_file = 'data/first-stage/03_firststage-data.xlsx'  # Replace with your Excel file path
    excel_data = pd.read_excel(excel_file)

    # Merge Excel data with GeoJSON data on "geom_id"
    merged_data = pd.merge(excel_data, swedish_parishes_wgs84[['geom_id', 'latitude', 'longitude']], on='geom_id', how='left')

    # Save the merged data to a new file (optional) as an excel file
    merged_data.to_excel('data/first-stage/04_firststage-data.xlsx', index=False)

    print("Data processing completed. Merged data saved as 04_firststage-data.xlsx")

if __name__ == "__main__":
    main()
