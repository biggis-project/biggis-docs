# Weather stations

!!! TODO
    Julian, Hannes, Jochen

## LUBW weather station at FZI

  - the device was mounted at FZI in January 2017 for measuring air pressure, temperature, wind speed, precipitation (was bedeuten die Parameter "strg_1" und "rlf_1").
  - measurement results (*.mw1.xml) are pushed via xml-files on BigGIS SFTP Server at the University Konstanz 
  -measurement devices will be dismounted at April 2018

## SenseBox-based weather stations
- support two different modes of data transmission: WLAN and LoRa
    - LoRa is preferred for longer range and easier deployment (no site-specific configuration)

- LoRa gateways
    - Two LoRa gateways should be deployed, one at FZI, the other at LUBW-KA (TODO:clarify)
    - Gateways are a [Kickstarter project](https://www.kickstarter.com/projects/419277966/the-things-network),
        and have not yet been delivered as of 2017-12-15. [Last status](https://www.kickstarter.com/projects/419277966/the-things-network/posts/2036596)
        on Kickstarter is that the gateways are ready to ship (2017-11-06)
    - Julian handles Kickstarter and deployment

- Data handling
    - a common Kafka queue for events from both transports
    - one Kafka message per transmitted event, containing all measurements (temperature, humidity, air pressure, internal temperature, light, UV radiation)
    - transport specific adapters for [WLAN](https://github.com/biggis-project/sensebox-station/tree/master/SenseBoxSimpleRestServer)
        and [LoRa](https://github.com/biggis-project/sensebox-station/tree/master/CodekunstMQTTAdapter)
    - should be handled in a stream-processing way (pipeline modeled using StreamPipes)
        - Data source and metadata enrichment exist as [StreamPipes components](../architecture/StreamPipes)
    - should be stored within BigGIS database i.e. Accumulo/Exasolution (sensor,lat,lon,ts)
        - a [Flink job](https://github.com/biggis-project/sensebox-station/tree/master/FlinkDbSink)
            that persists the events from the Kafka queue into MySQL or PostgreSQL exists,
            could be extended to support other JDBC databases
    - should be sent to https://opensensemap.org/ (TODO:Jochen)
    - Outlier filtering node (kafka->flink->kafka)

- Deployment
    - 34 LoRa sensor units should be deployed, Julian handles locations, external organizations etc.


## Web-based mobile-friendly app
- QR code contains stations id and URL that leads to public web
    - the web page contains info about the station and the project
    - admin can click and change station information (or register a new station)
    - lat/lon is taken from the phone (HTML5 geolocation api)
    - admin can add additional parameters (placement details)
