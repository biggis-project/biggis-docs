# StreamPipes

![StreamPipes Logo](https://www.streampipes.org/images/streampipes-logo-left.png)

Within the BigGIS project, we added several GIS-specific extensions to the StreamPipes platform.

With StreamPipes, it is possible to build distributed pipelines to process your data in real-time without development
effort by providing an easy-to-use graphical user interface on top of existing stream processing frameworks. Pipelines
consist of data streams, real-time event processors and data sinks. StreamPipes provides a system that can be used by
domain experts with little to no technical understanding to explore and analyse their data. The whole system is designed
in a way that it is flexible and can be easily extended by adding data streams, data processors or data sinks. A
community edition of StreamPipes is available under the Apache Licence.

- [Features Overview](https://www.streampipes.org/en/features)
- [Official Documentation](https://docs.streampipes.org/)


## Processing of climate data

### [SenseBoxAdapter](https://github.com/biggis-project/biggisstreampipes-senseboxadapter)

This component provides the semantic description for the externally created SenseBox data stream for the integration
into StreamPipes

datatype  | name | URI in RDF
----------|------|----------------
timestamp | createdAt
string    | boxId      | http://schema.org/id

### [SenseboxMetadataEnricher](https://github.com/biggis-project/biggisstreampipes-senseboxmetadataenricher)

This component enriches each message in the SenseBox measurements data stream with meta-data (location, OpenSenseMap-Id)

### [RasterDataEndlessSource](https://github.com/biggis-project/biggisstreampipes-rasterdataendlesssource)

This component generates an endless Kafka stream of rasterdata messages to easily test and debug other rasterdata
processing components

### [RasterDataAdapter](https://github.com/biggis-project/biggisstreampipes-rasterdataadapter)

This component provides the semantic description for the RasterDataEndlessSource
