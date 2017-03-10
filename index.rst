About BigGIS?
-------------------

BigGIS is a new generation of GIS that supports decision making in multiple
scenarios which require processing of large and heterogeneous data sets.

The novelty lies in an integrated analytical approach to spatio-temporal
data, that are unstructured and from unreliable sources. The system provides
predictive, prescriptive and visual tool integrated in a common analytical
pipeline.

.. |scen1| image:: images/scen-smartcity.*
.. |scen2| image:: images/scen-environment.*
.. |scen3| image:: images/scen-disaster.*

.. centered:: |scen1| |scen2| |scen3|

The project is evaluated on three scenarios:
 - “Smart city” (urban heat islands, particulate matter)
 - “Environmental management” (health threatening animals and plants)
 - “Disaster control, civil protection” (air pollution, toxic chemicals)

Please visit the `project site <http://biggis-project.eu>`__ for more
information as well as some interactive demos.


Why BigGIS?
-------------------

Current GIS solution are mostly tackling big data related requirements
in terms of data volume or data velocity. In the era of cloud computing,
leveraging cloud-based resources is a widely adopted pattern. In addition,
with the advent of big data analytics, performing massively parallel
analytical tasks on large-scale data at rest or data in motion is as well
becoming a feasible approach shaping the design of today’s GIS. Although
scaling out enables GIS to tackle the aforementioned big data induced
requirements, there are still two major open issues. Firstly, dealing with
varying data types across multiple data sources (variety) lead to data and
schema heterogeneity, e.g., to describe locations such as addresses, relative
spatial relationships or different coordinates reference systems. Secondly,
modeling the inherent uncertainties in data (veracity), e.g., real-world
noise and erroneous values due to the nature of the data collecting process.
Both being crucial tasks in data management and analytics that directly affect
the information retrieval and decision-making quality and moreover the generated
knowledge on human-side (value). By leveraging the the continuous refinement
model, we present a holistic approach that explicitly deals with all big data
dimensions. By integrating the user in the process, computers can learn from
the cognitive and perceptive skills of human analysis to create hidden
connections between data and the problem domain. This helps to decrease
the noise and uncertainty and allows to build up trust in the analysis results
on user side which will eventually lead to an increasing likelihood of relevant
findings and generated knowledge.

Contact and Support
-------------------

TODO

.. ===============================================
   Here comes the side menu with links to chapters
   ===============================================

.. toctree::
   :maxdepth: 2
   :caption: Home
   :hidden:

   contributing

.. toctree::
   :maxdepth: 2
   :caption: Architecture
   :glob:
   :hidden:

   architecture/containers
