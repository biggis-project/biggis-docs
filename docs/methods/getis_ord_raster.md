# Getis-ord G* on rasters

The [Standard Getis-ord](getis_ord.md) is defined on individual points (vector data).
In many situations, we want to compute $G^*_i$ in a raster rather than in a point cloud.
This way, the computation can be expressed using map algebra operations and nicely parallelized in frameworks 
such as [Geotrellis](https://geotrellis.io/).

The rasterized Getis-Ord formula looks as follows:

$$
G^*(R, W, N, M, S) =
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
