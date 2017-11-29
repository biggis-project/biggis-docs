!!! note "Responsible person for this section"
    Viliam Simko
    
# Hotspot analysis demo

- Phillip Zehnder used the NY-Taxi data in stream pipes
- We can take some text from GISCUP and from our papers.

## Problem specification

## Solution for GISCUP
!!! todo
    add link to GISCUP'16 website


## Hotspot analysis using geotrellis

In this section we show a simplified version of the hotspot analysis.
We use the geotrellis library to achieve the paralleization.
Some assumptions are:

- we use 2-dimenational data (only the spatial part without time component)
- we store our data as a distributed raster (in geotrellis catalog)
- our hotspot analysis uses the standard G* with variable window

First, we need to express the $G^*$ formula in terms of the map algebra operations.

### G* using map algebra operations

Given a raster $R$ (represented as a singleband raster layer in geotrellis catalog)
and a square weight matrix $W$ of size $n \times n$ we can use the following formula:
$$
G*(R, W) =
    \frac{R * W - GlobMeanTODO}
    {GlobSdTODO}
$$

First, we need to obtain two global values from the whole $R$:
- global mean $GlobMeanTODO$
- global standard deviation $GlobSdTODO$

Then, we can apply a **focal operation** $R * W$ - the convolution of raster $R$ with the weight matrix $W$.
After that, we apply a **local operation** on $R$ using the global mean $GlobMeanTODO$ and standard deviation
$GlobSdTODO$. 

### Geotrellis code

```scala
// INPUT: layerId, circleKernelRadius

val queryResult: RDD[(SpatialKey, Tile)] with Metadata[TileLayerMetadata[SpatialKey]] =
  layerReader.read[SpatialKey, Tile, TileLayerMetadata[SpatialKey]](srcLayerId)

val focalKernel = Kernel.circle(circleKernelRadius, queryResult.metadata.cellwidth, circleKernelRadius)

val convolvedLayerRdd = queryResult.withContext {
  rdd => rdd
    .bufferTiles(focalKernel.extent)
    .mapValues { tileWithContext =>
      tileWithContext.tile.focalSum(focalKernel, Some(tileWithContext.targetArea))
    }
}

// TODO: local operation with global meand and stdev
```