# Docker containers

!!! TODO
    Patrick

- all sources should be on github
- images should be hosted on dockerhub
- list of docker images that should be available:
    - HDFS (should use all bwCloud resources available to BigGIS)
    - Kafka with Zookeeper (overview of queues needed)
    - Flink
    - Spark
    - Geotrellis libraries (part of the Spark container?)
    - Accumulo with Geomesa (or Geowave)
    - StreamPipes
    - Exasolution
        - Exasolution should support Accumulo(Geomesa/Geowave) through virtual schema
        - Exasolution should support indexing using 2D, 3D, 4D space filling curves (lat,lon,time,elevation)
    - Geo-Server
        - mit Plugin für Accumulo
        - zur Transformation von Formaten
        - auch als Datenquelle für Cadenza
