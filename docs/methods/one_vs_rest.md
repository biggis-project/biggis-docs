# One vs. Rest

The One-versus-Rest (or One-versus-All = OvA) Strategy is a Method to use Binary (Two-Class) Classifiers
(such as [Support Vector Machines](../methods/support_vector_machine.md) ) for classifying multiple
(more than two) Classes.

!!! note 
    - https://en.wikipedia.org/wiki/Multiclass_classification#One-vs.-rest
    - https://spark.apache.org/docs/latest/ml-classification-regression.html#one-vs-rest-classifier-aka-one-vs-all

#### One-vs.-rest

##### Inputs
* $L \text{ , a learner (training algorithm for binary classifiers) }$
* $\text{ samples } \vec{X}$
* $\text{ labels } \vec{y} \\ \text{ where } y_i \in {1,\ldots,K} \text{ is the label for the sample } X_i$

##### Output
* $\text{ a list of classifiers } f_k \text{ for } k \in {1,\ldots,K}$

##### Procedure
$\text{ For each } k \text{ in } {1,\ldots,K}$

$$
\begin{align}
&\text{ Construct a new label vector } \vec{z} \text{ where }
\begin{cases}
z_i = 1, & \text{ if } y_i = k \\
z_i = 0, & \text{ otherwise }
\end{cases}\\
&\text{ Apply } L \text{ to } \vec{X}, \vec{z} \text{ to obtain } f_k \\
\end{align}\\
$$

Making decisions means applying all classifiers to an unseen sample and
predicting the label for which the corresponding classifier reports the
highest confidence score:

$$
\hat{y} = \underset{k \in \{1 \ldots K\}}{\text{argmax}}\; f_k(x)
$$


!!! todo
    Adrian Klink: Add references, optimize description
