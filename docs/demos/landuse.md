!!! note "Responsible person for this section"
    Adrian Klink (EFTAS)

# Landuse classification

!!! TODO
    - Describe the idea
    - Maybe add some geotrellis examples

!!! note
    Related repository is https://github.com/biggis-project/biggis-landuse
  
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
