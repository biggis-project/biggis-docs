# One vs. Rest

The One-versus-Rest (or One-versus-All = OvA) Strategy is a Method to use Binary (Two-Class) Classifiers (such as [Support Vector Machines](../methods/support_vector_machine.md) ) for classifying multiple (more than two) Classes.

!!! note 
    - https://en.wikipedia.org/wiki/Multiclass_classification#One-vs.-rest
    - https://spark.apache.org/docs/latest/ml-classification-regression.html#one-vs-rest-classifier-aka-one-vs-all

#### One-vs.-rest

##### Inputs:

        L, a learner (training algorithm for binary classifiers)
        samples X
        labels y where yi ∈ {1, … K} is the label for the sample Xi

##### Output:

        a list of classifiers fk for k ∈ {1, …, K}

##### Procedure:

        For each k in {1, …, K}
            Construct a new label vector z where zi = 1 if yi = k and zi = 0 otherwise
            Apply L to X, z to obtain fk

Making decisions means applying all classifiers to an unseen sample and
predicting the label for which the corresponding classifier reports the
highest confidence score:

$$\hat{y} = \underset{k \in \{1 \ldots K\}}{\arg\!\max}\; f_k(x)$$


!!! todo
    Adrian Klink: Add references, optimize description
