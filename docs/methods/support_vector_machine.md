# Support Vector Machine

!!! note 
    https://en.wikipedia.org/wiki/Support_vector_machine

Linear SVM
----------

We are given a training dataset of $n$ points of the form

:   $(\vec{x}_1, y_1),\, \ldots ,\, (\vec{x}_n, y_n)$

where the $y_i$ are either 1 or −1, each indicating the class to which
the point $\vec{x}_i$ belongs. Each $\vec{x}_i$ is a $p$-dimensional
[real](https://en.wikipedia.org/wiki/Real_number) vector. We want to find the
"maximum-margin hyperplane" that divides the group of points
$\vec{x}_i$ for which $y_i=1$ from the group of points for which
$y_i=-1$, which is defined so that the distance between the hyperplane
and the nearest point $\vec{x}_i$ from either group is maximized.

Any [hyperplane](https://en.wikipedia.org/wiki/Hyperplane) can be written as the set of
points $\vec{x}$ satisfying

:   $\vec{w}\cdot\vec{x} - b=0,\,$ 

where ${\vec{w}}$ is the (not necessarily normalized) [normal
vector](https://en.wikipedia.org/wiki/Normal_(geometry)) to the hyperplane. This is much
like [Hesse normal form](https://en.wikipedia.org/wiki/Hesse_normal_form), except that
${\vec{w}}$ is not necessarily a unit vector. The parameter
$\tfrac{b}{\|\vec{w}\|}$ determines the offset of the hyperplane from
the origin along the normal vector ${\vec{w}}$.

![Maximum-margin hyperplane and
    margins for an SVM trained with samples from two classes. Samples on
    the margin are called the support
    vectors.](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Svm_max_sep_hyperplane_with_margin.png/220px-Svm_max_sep_hyperplane_with_margin.png "fig:Maximum-margin hyperplane and margins for an SVM trained with samples from two classes. Samples on the margin are called the support vectors.")

### Hard-margin

If the training data are [linearly
separable](https://en.wikipedia.org/wiki/Linearly_separable), we can select two parallel
hyperplanes that separate the two classes of data, so that the distance
between them is as large as possible. The region bounded by these two
hyperplanes is called the \"margin\", and the maximum-margin hyperplane
is the hyperplane that lies halfway between them. These hyperplanes can
be described by the equations

:   $\vec{w}\cdot\vec{x} - b=1\,$

and

:   $\vec{w}\cdot\vec{x} - b=-1.\,$

Geometrically, the distance between these two hyperplanes is
$\tfrac{2}{\|\vec{w}\|}$, so to maximize the distance between the planes
we want to minimize $\|\vec{w}\|$. As we also have to prevent data
points from falling into the margin, we add the following constraint:
for each $i$ either

:   $\vec{w}\cdot\vec{x}_i - b \ge 1,$ if $y_i = 1$

or

:   $\vec{w}\cdot\vec{x}_i - b \le -1,$ if $y_i = -1.$

These constraints state that each data point must lie on the correct
side of the margin.

This can be rewritten as:

:   $y_i(\vec{w}\cdot\vec{x}_i - b) \ge 1, \quad \text{ for all } 1 \le i \le n.\qquad\qquad(1)$

We can put this together to get the optimization problem:

:   \"Minimize $\|\vec{w}\|$ subject to
    $y_i(\vec{w}\cdot\vec{x}_i - b) \ge 1,$ for $i = 1,\,\ldots,\,n$\"

The $\vec w$ and $b$ that solve this problem determine our classifier,
$\vec{x} \mapsto \sgn(\vec{w} \cdot \vec{x} - b)$.

An easy-to-see but important consequence of this geometric description
is that the max-margin hyperplane is completely determined by those
$\vec{x}_i$ which lie nearest to it. These $\vec{x}_i$ are called
*support vectors.*

### Soft-margin

To extend SVM to cases in which the data are not linearly separable, we
introduce the *hinge loss* function,

:   $\max\left(0, 1-y_i(\vec{w}\cdot\vec{x}_i + b)\right).$

This function is zero if the constraint in (1) is satisfied, in other
words, if $\vec{x}_i$ lies on the correct side of the margin. For data
on the wrong side of the margin, the function\'s value is proportional
to the distance from the margin.

We then wish to minimize

:   $\left[\frac 1 n \sum_{i=1}^n \max\left(0, 1 - y_i(\vec{w}\cdot \vec{x}_i + b)\right) \right] + \lambda\lVert \vec{w} \rVert^2,$

where the parameter $\lambda$ determines the tradeoff between increasing
the margin-size and ensuring that the $\vec{x}_i$ lie on the correct
side of the margin. Thus, for sufficiently small values of $\lambda$,
the soft-margin SVM will behave identically to the hard-margin SVM if
the input data are linearly classifiable, but will still learn if a
classification rule is viable or not.


!!! todo
    Adrian Klink: Add description, formula, references
