# Standards Getis-Ord G*

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

!!! todo
    Julian Bruns: Add references to papers
