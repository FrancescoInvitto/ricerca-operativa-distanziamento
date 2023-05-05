# ricerca-operativa-distanziamento
Project developed for the Ricerca Operativa course of Master Degree at University of Parma.

# Description of the problem
The assignment is about formulating a mathematical model to identify the maximum number of students that can be contained in a classroom respecting a
minimum distance of dmin meters. In addition to defining the mathematical model in AMPL we are asked to locate a particular instance, defining its data, and to solve it. Furthermore, it is required to carry out an analysis of what happens if some data of that instance are modified. The first thing we did was identify the components that distinguish each decision problem, i.e. the data, the variables, the constraints and the target; so let's go and specify them.

## Data
The data represent all those quantities that are not under the direct control of the decision maker, but they are fixed a priori; so in our case we will have as given certainly the minimum distance dmin that must be respected inside the classroom. Another data hidden in the text derives from the structure of the classroom, i.e. it concerns the distance that exists between the various seats available in the classroom; we indicate this data with dij, and represents the distance between place i and place j.

## Variables
The variables represent all those quantities which, unlike the data, are below the direct control of the decision maker, who can therefore modify its value. In our case we have associated a binary variable x_i to each place in the classroom with the following meaning:
```math
x_i = {
    1 if the place i is occupied,
    0 otherwise
}
```

## Constraints
The constraints represent a limitation of the value that the various can assume problem variables. In our case the constraint we have imposed is that
relating to compliance with the minimum distance:
```math
\sum_{i=1}^{n}\sum_{j=1}^{n} x_i+x_j \leq 1 \quad \forall i, j: d_{ij} < d_{min}
```
that is, for any pair of places i and j such that the distance between them is strictly lower than the minimum (dmin) the sum of the relative binary variables must be not higher than 1; this dictates that, since binary variables can assume only value 0 and 1, when the condition indicated occurs only one of the two binary variables can assume the value 1, while the other must necessarily have value 0, so that the constraint is satisfied. This is equivalent to saying that only one of the two seats i and j can be occupied, while the other must be necessarily left free.

## Goal
The goal of the problem is the criterion used to determine which solution is thebest of all eligible ones. For our problem the goal is to maximize the number of students that can be contained within the classroom or, in entirely equivalent way, maximize the number of seats occupied inside of the classroom. Therefore this objective can be expressed as:
```math
max \sum_{i=1}^{n} x_i
```
Observe that only the variables that are associated with occupied seats will provide a non-zero contribution to the summation. So the goal is maximize the number of binary variables set to 1.

# Mathematical model
By putting all the components together we can then derive the mathematical model for our problem:
```math
max \sum_{i=1}^{n} x_i
```
subject to:
```math
x_i + x_j ≤ 1   ∀ i, j : d_{ij} < d_{min}
```
```math
0 ≤ x_i ≤ 1
```
```math
x_i ∈ Z         ∀ i = 1, ..., n
```
where the last line relates to the binary constraint of the variables. Now let's translate the mathematical model “on paper” into AMPL language; we have to
carry out a translation of all the elements of the problem, therefore data, variables, constraint and goal.

## Data
As regards the data, it is necessary to distinguish between sets of indices and parameters. To us we need two sets of indexes:
  1. a set of places;
  2. a set of distances between all pairs of places.
We declare them as follows:
set POSTI;
set DISTANZE within (POSTI cross POSTI);

We observe how we declared the second set as a subset of Cartesian product of the set of places with itself. As for the parameters we must declare the minimum distance and a vector of distances, respectively:
params dmin >= 0;
param d{DISTANCE} >= 0;
In both cases we already impose that the values are non-negative, as it does not have sense to speak of negative distances.

## Variables
As for the variables we have only the binary variables associated with the various seats in the classroom. We will then have a vector of binary variables declared in the following way:
var x{POSTI} binary;
We will have as many binary variables as there are elements of the set of indices POSTI, the keyword binary indicates precisely that these variables will be binary.

## Constraints
We have seen that there is only one set of constraints for our problem; we translate it as follows:
subject to minimum_distance {(i, j) in DISTANCES : d[i, j] < dmin} : x[i] + x[j] <= 1;
We observe how there will be a constraint for each pair of places (i, j) present in the set DISTANCES for which the property that the distance between such places is strictly less than the minimum distance to be respected, while it will not be there is a constraint for the other pairs of seats (i.e. those for which there is one distance at least equal to the minimum distance).

## Goal
Finally, the goal of the problem must also be translated into AMPL, which is done in the following way:
maximize seats_occupied : sum{i in SEATS} x[i];
The keyword "maximize" tells us that ours is a problem of maximum, the goal formula is easily understood as the sum of the binary variables associated with each single seat in the classroom, exactly as we have commented earlier. By putting everything together we can create the spacing.mod file, which contains
the mathematical model of our problem.
