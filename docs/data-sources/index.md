# Datasets in BigGIS
## Data in bwCloud

Pre-cached / downloaded to bwCloud as a part of BigGIS

  - ATKIS land use data (multiple options possible - TODO:Matthias) TODO:how big
    - shapefiles in a directory
    - data in Accumulo/Exasolution
  - New York taxi drives
    - 2GB/month -> for years 2009-2015 potentially ~160GB of storage space
    - multiple options possible - TODO:Matthias
    - bunch of CSV files in a directories organized per year
    - points stored in Accumulo
    - points stored in Exasolution
- Large historical data sets (HDFS/Accumulo - TODO:Matthias):
  - LUBW (REST API for pulling)
  - DWD (REST API for pulling)
  - Volunteered Meteorological Information (Wunderground) (TODO:UKON)
  - Air Pollution Data (Umweltbundesamt) 
  - Drosophila Suzukii Observations (Vitimeteo)
  - Satellite Land-Surface-Temperature (MODIS Satellite)
  - Traffic Incidents (Bing Traffic API)
  - Volunteered Geographic Information (enviroCar)

## Connectors to external services
The following connectors to external data sources should be available (for pulling data as a stream).

- Pulling data:
  - Envisat raster data
  - Landsat raster data
  - DWD weather stations
  - LUBW weather stations
  - Wunderground weather stations

- Pushing data (REST API needs to be developed from our side):
  - Sensor data from LoRa weather stations
  - VGI data -> compare KA Feedback (TODO)
  - TODO: hyperspectral images from drones (TODO)
  - TODO: other sensor data from drones (TODO)
