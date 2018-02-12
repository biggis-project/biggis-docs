# Sentinel 2

!!! todo
    Adrian (EFTAS)
    : optimize text

Used in [Landuse classification](../../../demos/landuse.md) as input to classify landcover for the landuse analysis 

## Description

Sentinel 2 dataset is multispectral satellite raster data with 13 bands in the visible (RGB), near infrared (NIR) and short wave infrared (SWIR) spectrum.
It can be updated approximately every 5 days. The Sentinel-2A and 2B satellites are operated by the European Space Agency (ESA) as part of the Copernicus Programme.

see: https://en.wikipedia.org/wiki/Sentinel-2

## Source of the data is the ESA Sentinel Portal

- ESA: - https://sentinel.esa.int/web/sentinel/missions/sentinel-2/data-products
    - Sentinel Tiles - [Sentinel-2 tiling grid kml](https://sentinel.esa.int/documents/247904/1955685/S2A_OPER_GIP_TILPAR_MPC__20151209T095117_V20150622T000000_21000101T000000_B00.kml)
    - Access to Sentinel Data - https://sentinel.esa.int/web/sentinel/sentinel-data-access
        - Copernicus Open Access Hub - https://scihub.copernicus.eu/dhus/#/home

### Alternative Sources
- AWS: - https://aws.amazon.com/de/public-datasets/sentinel-2/

Example download (Tile 32UMU - 2016-05-05 - bands B2,B3,B4,B8 - Blue Green Red NIR )
```bash
wget http://sentinel-s2-l1c.s3.amazonaws.com/tiles/32/U/MU/2016/5/5/0/B02.jp2
wget http://sentinel-s2-l1c.s3.amazonaws.com/tiles/32/U/MU/2016/5/5/0/B03.jp2
wget http://sentinel-s2-l1c.s3.amazonaws.com/tiles/32/U/MU/2016/5/5/0/B04.jp2
wget http://sentinel-s2-l1c.s3.amazonaws.com/tiles/32/U/MU/2016/5/5/0/B08.jp2
```

## Sentinel 2 bands and resolutions

| Band | Bandname             | Central Wavelength (µm) | Resolution (m) | Bandwidth (nm) |
|------|----------------------|-------------------------|----------------|----------------|
| 1    | Coastal aerosol      | 0.443                   | 60             | 20             |
| 2    | Blue                 | 0.490                   | 10             | 65             |
| 3    | Green                | 0.560                   | 10             | 35             |
| 4    | Red                  | 0.665                   | 10             | 30             |
| 5    | Vegetation Red Edge  | 0.705                   | 20             | 15             |
| 6    | Vegetation Red Edge  | 0.740                   | 20             | 15             |
| 7    | Vegetation Red Edge  | 0.783                   | 20             | 20             |
| 8    | NIR                  | 0.842                   | 10             | 115            |
| 8A   | Narrow NIR           | 0.865                   | 20             | 20             |
| 9    | Water vapour         | 0.945                   | 60             | 20             |
| 10   | SWIR – Cirrus        | 1.375                   | 60             | 20             |
| 11   | SWIR                 | 1.610                   | 20             | 90             |
| 12   | SWIR                 | 2.190                   | 20             | 180            |

### 10m bands

| Band | Bandname             | Central Wavelength (µm) | Resolution (m) | Bandwidth (nm) |
|------|----------------------|-------------------------|----------------|----------------|
| 2    | Blue                 | 0.490                   | 10             | 65             |
| 3    | Green                | 0.560                   | 10             | 35             |
| 4    | Red                  | 0.665                   | 10             | 30             |
| 8    | NIR                  | 0.842                   | 10             | 115            |

### 20m bands

| Band | Bandname             | Central Wavelength (µm) | Resolution (m) | Bandwidth (nm) |
|------|----------------------|-------------------------|----------------|----------------|
| 5    | Vegetation Red Edge  | 0.705                   | 20             | 15             |
| 6    | Vegetation Red Edge  | 0.740                   | 20             | 15             |
| 7    | Vegetation Red Edge  | 0.783                   | 20             | 20             |
| 8A   | Narrow NIR           | 0.865                   | 20             | 20             |
| 11   | SWIR                 | 1.610                   | 20             | 90             |
| 12   | SWIR                 | 2.190                   | 20             | 180            |

### 60m bands

| Band | Bandname             | Central Wavelength (µm) | Resolution (m) | Bandwidth (nm) |
|------|----------------------|-------------------------|----------------|----------------|
| 1    | Coastal aerosol      | 0.443                   | 60             | 20             |
| 9    | Water vapour         | 0.945                   | 60             | 20             |
| 10   | SWIR – Cirrus        | 1.375                   | 60             | 20             |

