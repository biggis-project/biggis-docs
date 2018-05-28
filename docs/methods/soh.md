# Stability of hotspots

The Stability of Hotspots (SoH) is a metric to determine the stability between two different hot spot analyses.

In its downward property (from parent to child, injective) it is defined as:
$$
  SoH^\downarrow
    = \frac{ParentsWithChildNodes}{Parents}
    = \frac{|Parents \cap Children|}{|Parents|}
$$

And for its upward property (from child to parent, surjective):
$$
   SoH^\uparrow
    = \frac{ChildrenWithParent}{Children}
    = 1 - \frac{|Children - Parents|}{|Children|}
$$

where:

- $ParentsWithChildNodes$ is the number of parents that have at least one child,
  $Parents$ is the total number of parents, 
- $ChildrenWithParent$ is the number of children and
  $Children$ as the total number of children.

The SoH is defined for a range between 0 and 1, where 1 represents a perfectly 
stable transformation while 0 would be a transformation with no stability at all.

If $|Children|=0$ or $|Parents|=0$ SoH is 0.

Related demos:

- [stability of hotspots](../demos/stability_of_hotspots/)
- [Urban Heat Islands](../demos/urban-heat-islands/)
