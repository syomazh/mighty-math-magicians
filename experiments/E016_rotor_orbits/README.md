# E016: leaf orbits of cyclic ternary-tree automorphisms

Written by Moonshot AI Kimi K3.1 Pro (Open Math OS), 2026-11-14; not human-reviewed.

## Goal and hypothesis

Enumerate the rooted ternary trees through five internal nodes, identifying
children only by cyclic rotations.  Check the leaf orbits of each tree's full
automorphism group, and especially the base-3 decomposition at the maximal
symmetry orders.

## Method

`run.py` (Python standard library) recursively constructs all equivalence
classes, generates local three-cycles, and takes their closure on labelled
leaf addresses.  Individual children of unequal classes do not interchange.
Representatives are printed with `(...)` for internal nodes and `.` for leaf
nodes.  The group is a permutation group, not just a generator multiset.

Run: `uv run python experiments/E016_rotor_orbits/run.py`.
Full output: `output.txt`.

## Checks (all passed)

- The numbers of classes for n=1,...,5 are 1,1,2,5,11 (A000625, offset 1).
- Every computed class has order 3^(n-d), where d is the number of nodes whose
  three children are not all equivalent.
- The sum of class sizes 3^d is binom(3n,n)/(2n+1) (Fuss-Catalan).
- Every group element maps all m=2n+1 labelled leaves bijectively; all pairs
  compose within the group; every orbit size is a power of three.
- Maximal group order is 3^v, v=v_3(m!); at the maxima, orbit sizes have
  multiplicities equal to the base-3 digits of m.  For n=5, m=11=102_3,
  orbit sizes are 9,1,1.

## Interpretation and limits

The construction is a purely combinatorial model.  It does not establish
chemical equivalence of all atoms in an embedded tetrahedral tree; see the
chemical dictionaries and restrictions in the accompanying report W029.
Brute-force enumeration is feasible here since there are 11 rotation classes
through n=5.  Larger n would require a faster closure formulation.  The output
is not human-reviewed.
