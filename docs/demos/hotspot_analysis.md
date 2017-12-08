# Hotspot analysis

[Responsible person]: "Viliam Simko"
[Geotrellis]: https://github.com/locationtech/geotrellis

## Problem definition

- We have a map, e.g. a map of temperatures or a map of taxi drop-offs.
- We want to find hotspots, i.e., areas on map that are **significantly different from their surrounding area**.
- We want to use Getis-Ord $G^*_i$ statistic as the tool for finding hotspots
    - see section [Standards Getis-ord](../methods/getis_ord.md)
- We want to parallelize the computation in our Spark cluster.
    - see section [Rasterized Getis-ord](../methods/getis_ord_raster.md)

## Hotspot analysis using geotrellis

In this section we show a simplified version of the hotspot analysis.
We use the [Geotrellis] library to achieve the paralleization.
Some assumptions are:

- we use 2-dimenational data (only the spatial part without time component)
- we store our data as a distributed raster (in geotrellis catalog)
- our hotspot analysis uses the standard G* with variable window

First, we need to express the $G^*$ formula in terms of the map algebra operations.

### Scala code snippets

```scala
// typical type definition used by geotrellis
type SpatialRDD = RDD[(SpatialKey, Tile)]
                  with Metadata[TileLayerMetadata[SpatialKey]]
  
def getisord(rdd: SpatialRDD, weightMatrix: Kernel,
             globMean:Double, globStdev:Double, numPixels:Long): SpatialRDD = {

  val wcells = weightMatrix.tile.toArrayDouble
  val sumW = wcells.sum
  val sumW2 = wcells.map(x => x*x).sum
  
  val A = globMean * sumW
  val B = globStdev * Math.sqrt((numPixels*sumW2 - sumW*sumW) / (numPixels - 1))

  rdd.withContext {
    _.bufferTiles(weightMatrix.extent)
      .mapValues { tileWithCtx =>
        tileWithCtx.tile
          .focalSum(weightMatrix, Some(tileWithCtx.targetArea)) // focal op.
          .mapDouble { x => (x - A) / B } // local op.
      }
  }
}
```

Let's assume, we already have `layerReader`, `srcLayerId`, `kernelRadius`, `globMean`, `globStdev` and `numPixels`:

```scala
val queryResult: SpatialRDD =
  layerReader.read[SpatialKey, Tile, TileLayerMetadata[SpatialKey]](srcLayerId)

// here, we use a circular kernel as a weight matrix
val weightMatrix = Kernel.circle(kernelRadius,
                                 queryResult.metadata.cellwidth,
                                 kernelRadius)

val outRdd = getisord(queryResult, weightMatrix, globMean, globStdev, numPixels)
```
You can not further process `outRdd` or store it as a new layer.
