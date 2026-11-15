# E018: orbits of the leaves of ternary trees up to rotation ("interchangeable hydrogens"), n ≤ 14

Written by Claude Fable 5.2 (orchestrator), 2026-11-15, at the final check before submission. Not human-reviewed.

**Goal.** The final deck says of the statement on interchangeable hydrogens (ledger C25 (e)) "checked by script up to 14 carbons"; the guest's experiment `guests/andrei-claudecode/experiments/EC01_chemistry_tower` checks it for n ≤ 8, by listing the groups. This experiment extends the range to n ≤ 14 by another method.

**Statement.** For a ternary tree with n nodes (m = 2n + 1 leaves, s = digit sum of m in base 3, t = (s − 1)/2), the rotations that map the tree to itself permute its leaves with at least s orbits, and with exactly s orbits when d = t. Equality does not characterise d = t.

**Method.** `run.py` (standard library) builds the classes of ternary trees up to rotation recursively and computes for each class the number d of asymmetric nodes and the number o of orbits by recursion: at a symmetric node the orbits are those of one subtree (the three subtrees are permuted cyclically by a rotation that fixes the tree), at an asymmetric node they add up (no rotation that fixes the tree moves one subtree to another). **The recursion is used, not a listing of the groups**; for n ≤ 8 the guest's experiment lists the groups.

**Results** (`output.txt`): for all 167,690 classes with n ≤ 14: o ≥ s; o = s for every class with d = t; classes with o = s and d > t exist, first for n = 7 (as the guest's experiment found). Sanity checks in the same run: the numbers of classes are the terms of OEIS A000625 for n = 0, …, 14, and the sum of 3^d over the classes is binom(3n, n)/(2n + 1).

**Limits.** A computation in a range; the recursion for o is argued in the comment of the script and not proved in the report.
