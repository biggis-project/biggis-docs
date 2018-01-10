# StreamPipes

!!! note "Responsible person for this section"
    Matthias Frank

## BigGIS extensions
 
Within the BigGIS project, we added several GIS-specific extensions to the StreamPipes platform.

- Climate data
    - [SenseBoxAdapter](https://github.com/biggis-project/biggisstreampipes-senseboxadapter)

        provides the semantic description for the externally created SenseBox data stream
        for the integration into StreamPipes

    - [SenseboxMetadataEnricher](https://github.com/biggis-project/biggisstreampipes-senseboxmetadataenricher)

        enriches each message in the SenseBox measurements data stream with meta-data (location, OpenSenseMap-Id)

- Raster processing using geotrellis.
    - [RasterDataEndlessSource](https://github.com/biggis-project/biggisstreampipes-rasterdataendlesssource)

        generates an endless Kafka stream of rasterdata messages to easily test and debug
        other rasterdata processing components

    - [RasterDataAdapter](https://github.com/biggis-project/biggisstreampipes-rasterdataadapter)

        provides the semantic description for the RasterDataEndlessSource
