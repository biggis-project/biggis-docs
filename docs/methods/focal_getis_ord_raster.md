# Foal Getis-ord on rasters

The rasterized Focal Getis-Ord formula looks as follows:

$$
FocalG^*(R, W, N, M, S) =
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
- $N$ represents the focal count of pixels TODO (there can be NA values)
- $M$ represents the focal mean TODO.
- $S$ represents the focal standard deviation TODO.

It can be seen that the formula can be nicely refactored into:

- TODO