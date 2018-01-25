# Landuse classification

[Responsible person]: "Adrian Klink"

!!! note
    Related repository is https://github.com/biggis-project/biggis-landuse

## Problem definition

- We have the following datasets:
    - An existing Landuse vector dataset
    - Orthorectified Aerial images (Digital Ortho Photos = DOP) 
    - Satellite images (SAT), e.g. Sentinel2 10m
- We want to select / extract landcover classes from landuse classes.
- We want to use Support Vector Machines (or other Machine Learning Classifiers) for classifying landcover classes.
    - see section [Support Vector Machines](../methods/support_vector_machine.md)
- We want to support Multiple classes using a One versus All (OvA) strategy or One vs. Rest.
    - see section [One vs. Rest](../methods/one_vs_rest.md)
- We want to parallelize the computation in our Spark cluster using [Geotrellis](https://geotrellis.io/) for data loading and export.

!!! note "Responsible person for this section"
    Adrian Klink (EFTAS)

!!! TODO
    - Describe the idea
    - Maybe add some geotrellis examples


## Classification of Aerial Images according to Land Use Classes (using Land Cover Classes as intermediate)

## Tools
- Machine Learning
- Training: Multiclass SVM
- Geotrellis

### Scala code snippets

```scala
type SpatialMultibandRDD = RDD[(SpatialKey, MultibandTile)] with Metadata[TileLayerMetadata[SpatialKey]]

// reading from Hadoop Layer (HDFS)
val rdd : SpatialMultibandRDD = biggis.landuse.api.readRddFromLayer(LayerId(layerName, zoom))
      
// writing to Hadoop Layer (HDFS)
biggis.landuse.api.writeRddToLayer(rdd, LayerId(layerName, zoom))
```

## Example
- Classification of Aerial Images May-Aug 2016
- Layerstacking: Aerial Images + Satellite images (IR, Resolution 2m)
- Training of a Multiclass SVM with manually selected training data (classified image tiles)

## Further Steps
- Adding additional Layers, e.g.
- Terrain Height
- Homogeneity of Texture
- Using Other Classififiers

## Related Scenarios
- [Environment](../scenarios/03_env.md)
- [Smart City](../scenarios/01_city.md)
