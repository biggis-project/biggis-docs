# About Exasolution

EXASolution is a flexibly scalable database management system from EXASOL that transfers efficient algorithmic solution models from the field of high-performance cluster computing to the analytical challenges in the Business Intelligence environment. Highly adaptive data distribution algorithms enable EXASolution to achieve high data throughput, eliminating the need for expensive storage systems.

- **Massively parallel data processing**:
  EXASolution was developed as a parallel system and is based on the "shared nothing" principle. The data is distributed across all nodes of a cluster. For queries, all nodes work together, whereby special parallel algorithms ensure that the data is calculated locally in the working memory of the nodes.

- **Intelligent in-memory algorithms**:
  In contrast to disk-based algorithms in traditional solutions, EXASolution can access each individual date individually. The access time is in the nanosecond range. The algorithms that process the queries are specially designed for the properties of the main memory and thus enable optimum performance.

- **Innovative compression algorithms**:
  As a further result of several years of research, EXASOL uses unique compression algorithms that enable efficient main memory consumption and thus sustainably reduce system costs. The data is compressed element by element in the main memory, so that the advantages of in-memory processing can be used even more efficiently.

EXASolution already supports a number of technologies that make EXASolution a solid basis for data management in BigGIS, among others:

- **Geodata support**:
  Spatial information can be stored and analyzed using geodata. Points, lines or surfaces (polygons) are defined via coordinates and saved in EXASolution as GEOMETRY objects. A large number of functions are provided for geodata objects in order to carry out various calculations and operations.

- **IMPORT/EXPORT**:
  The IMPORT/EXPORT SQL statements represent a very simple and at the same time extremely high-performance and flexible mechanism for transferring very large amounts of data between various databases or storage systems and EXASolution. This is achieved by automatic parallel processing and distribution of the data flows across many nodes.

- **EXAPowerlytics**:
  EXAPowerlytics offers the possibility to program specialized analysis, processing and generation functions and to execute them in parallel within EXASolution in a high-performance cluster (In Database Analytics). With this principle, many problems that were previously unthinkable in SQL can be solved very efficiently. EXAPowerlytics thus represents a flexible interface with which almost any requirements can be implemented.
