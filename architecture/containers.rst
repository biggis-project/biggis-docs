Docker containers
-----------------

TODO: Patrick

- all sources should be on github [1]
- images should be hosted on dockerhub (probably except exasolution ? TODO:Oleksandr)
- list of docker images that should be available:
  - HDFS (should use all bwCloud resources available to BigGIS)
  - Kafka with Zookeeper (TODO:Patrick - overview of queues needed)
  - Flink
  - Spark
    - Geotrellis libraries (part of the Spark container ? TODO:Patrick)
  - Accumulo with Geomesa (or Geowave, TODO:Patrick)
  - StreamPipes
  - Exasolution
    - Exasolution should support Accumulo(Geomesa/Geowave) through virtual schema
    - Exasolution should support indexing using 2D, 3D, 4D space filling curves (lat,lon,time,elevation)
  - Geo-Server
    - mit Plugin für Accumulo
    - zur Transformation von Formaten
    - auch als Datenquelle für Cadenza
