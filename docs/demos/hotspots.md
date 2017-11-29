# Hotspot analysis demo

[Responsible person]: "Viliam Simko"
[Geotrellis]: https://github.com/locationtech/geotrellis

## Problem definition

- We have a map, e.g. a map of temperatures or a map of taxi drop-offs.
- We want to find hotspots, i.e., areas on map that are **significantly different from their surrounding area**.
- We want to use Getis-Ord $G^*_i$ statistic as the tool for finding hotspots.
- We want to parallelize the computation in our Spark cluster.

## Standards Getis-Ord

The standard definition of Getis-Ord $G^*_i$ statistic assumes a study area with $n$ points with measurements
$X = [x_1, \ldots, x_n]$. Moreover, it assumes weights $w_{i,j}$ to be defined between all pairs of points $i$
and $j$ (for all $i,j \in \{ 1, \ldots, n\}$). The formula to compute $G^*_i$ at a given point $i$ is then:

$$
    G^*_i = \frac{
        \sum_{j=1}^{n}w_{i,j}x_j - \bar{X}\sum_{j=1}^{n}w_{i,j}
    }{
        S \sqrt{
            \frac{
              n \sum_{j=1}^{n}w_{i,j}^2 - (\sum_{j=1}^{n}w_{i,j})^2
            }{n-1}
        }
    }
$$

where:

- $\bar{X}$ is the mean of all measurements,
- $S$ is the standard deviation of all measurements.

As it is known, this statistic creates a z-score, which denotes the significance of an area in relation
to its surrounding areas.

!!! note
    For $x \in X$, the $zscore(x) = \frac{x - mean(X)}{stdev(X)}$

## Getis-ord on rasters

In many situations, we want to compute $G^*_i$ in a raster rather than in a point cloud.
This way, the computation can be expressed using map algebra operations and nicely parallelized in frameworks 
such as [Geotrellis].

The rasterized Getis-Ord formula looks as follows:

$$
G^*(R, W) =
    \frac{
        R{\stackrel{\mathtt{sum}}{\circ}}W
        - M*\sum_{w \in W}{w}
    }{
        S \sqrt{
          \frac{
            N*\sum_{w \in W}{w^2} - (\sum_{w \in W}{w})^2
          }{
            N - 1
          }
        }
    }
$$

where:

- $R$ is the input raster.
- $W$ is a weight matrix of values between 0 and 1.
  The matrix is square and has odd dimensions, e.g. $5 \times 5$, $31 \times 31$ ...
- $N$ represents the number of all pixels in $R$ (because there can be NA values)
- $M$ represents the global mean of $R$.
- $S$ represents the global standard deviation of all pixels in $R$.

It can be seen that the formula can be nicely refactored into:

- One **global operation** that computes $N$, $M$, $S$. These values are usually available because they
  were pre-computed when the raster layer has been ingested into the catalog.
- One **focal operation** $R{\stackrel{\mathtt{sum}}{\circ}}W$ - the convolution of raster $R$ with
  the weight matrix $W$.
- One **local operation** that puts all components toghether for each pixel in $R$.

## Hotspot analysis using geotrellis

In this section we show a simplified version of the hotspot analysis.
We use the [Geotrellis] library to achieve the paralleization.
Some assumptions are:

- we use 2-dimenational data (only the spatial part without time component)
- we store our data as a distributed raster (in geotrellis catalog)
- our hotspot analysis uses the standard G* with variable window

First, we need to express the $G^*$ formula in terms of the map algebra operations.


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