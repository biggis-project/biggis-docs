# Weather stations

!!! TODO
    Julian, Hannes, Jochen

## LUBW weather station at FZI

  - the device was mounted at FZI in January 2017 for measuring air pressure, temperature, wind speed, precipitation (was bedeuten die Parameter "strg_1" und "rlf_1").
  - measurement results (*.mw1.xml) are pushed via xml-files on BigGIS SFTP Server at the University Konstanz 
  -measurement devices will be dismounted at April 2018

## LoRa-based weather stations
- Two LoRa gateways should be deployed, one at FZI, the other at LUBW-KA (TODO:clarify)
- Data received by the LoRa gateways:
  - should be handled in a stream-processing way (pipeline modeled using StreamPipes)
  - should be stored within BigGIS database i.e. Accumulo/Exasolution (sensor,lat,lon,ts)
  - should be sent to https://opensensemap.org/ (TODO:Jochen)
- 34 LoRa sensor units should be deployed (by Jochen Lutz)
  - REST API for pushing developed using Play2 framework (REST->kafka)
  - Outlier filtering node (kafka->flink->kafka)
  - Data persisting node (kafka->flink->accumulo)

## Web-based mobile-friendly app
- QR code contains stations id and URL that leads to public web
  - the web page contains info about the station and the project
  - admin can click and change station information (or register a new station)
  - lat/lon is taken from the phone (HTML5 geolocation api)
  - admin can add additional parameters (placement details)
