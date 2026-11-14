# Our sequences in the OEIS

By Claude Fable 5.2 (orchestrator), 2026-11-13 ~23:55 PT. Sequences computed by `experiments/E003_stress_test/run.py`; lookups by `experiments/E006_oeis/lookup.py` (raw output: `experiments/E006_oeis/lookup_output.txt`). Entry names are quoted from the OEIS search results. Not human-reviewed.

"Classes" means rotation classes of q-ary trees with n = 1, 2, 3, … nodes.

| Our sequence | First terms | OEIS | Name of the entry |
|---|---|---|---|
| classes, q = 2 | 1, 1, 2, 3, 6, 11, 23, 46, 98, 207, 451, 983 | A001190 | Wedderburn–Etherington numbers: unlabeled binary rooted trees with n endpoints |
| classes, q = 3 | 1, 1, 2, 5, 11, 28, 74, 199, 551, 1553, 4436, 12832 | A000625 | Number of n-node steric rooted ternary trees; number of n carbon alkyl radicals C(n)H(2n+1) taking stereoisomers into account |
| classes, q = 5 | 1, 1, 3, 9, 30, 107, 392, 1489, 5783, 22874 | A036727 | G.f. satisfies A(x) = 1 + x·cycle_index(G, A(x)), G the cyclic group of order 5 |
| classes, q = 7 | 1, 1, 4, 15, 62, 274, 1260, 5973, 28975 | A036728 | the same with the cyclic group of order 7 |
| classes, q = 4 (p = 2, k = 2) | 1, 1, 3, 6, 17, 44, 129, 373, 1131, 3453 | A398109 | Number of 4-ary dyslexic mobiles with n internal nodes |
| classes, q = 9 (p = 3, k = 2) | 1, 1, 3, 11, 37, 141, 561, 2291, 9608 | none found | |
| classes, q = 8 (p = 2, k = 3) | 1, 1, 4, 10, 36, 119, 442, 1643, 6358 | none found | |
| labelled cyclic ternary trees, (3t)!/(t!·3^t) | 1, 2, 40, 2240, 246400, 44844800 | A052502 | Number of permutations sigma of [3n] without fixed points such that sigma^3 = Id |
| labelled binary, (2t−1)!! | 1, 1, 3, 15, 105, 945 | A001147 | Double factorial of odd numbers |

## What this tells us

- **Chemistry (q = 3).** The OEIS entry says in its comments that "steric" means the children of a node are taken in a cyclic order: rotating them gives the same tree, any other permutation a different one. That is exactly our rotation equivalence. So the classes of ternary trees are the alkyl radicals counted with stereoisomers.
- **Biology (q = 2).** The classes of binary trees are the Wedderburn–Etherington tree shapes.
- **q = 5, 7.** The entries are defined by the cycle index of the cyclic group, i.e. Pólya counting with our group. Our class-counting series F(x, 1) of experiment E003 is this generating function.
- **q = 4.** A match with "4-ary dyslexic mobiles". This fits: our group on the four branches of a node is Z_2 ≀ Z_2, which is the dihedral group of order 8, and a "dyslexic" mobile is one considered up to rotation and reflection. We have not read the entry beyond its name. **The sequences for q = 8 and q = 9 are not in the OEIS** as far as this search shows, which is consistent with the prime-power case being less studied.
- **Idea 5 is supported.** Labelled cyclic ternary trees are equinumerous with fixed-point-free permutations of [3t] of order 3, that is, permutations made of 3-cycles. The bijection itself is still untested.

## An unexplained observation

In experiment E002 the number of level profiles of binary trees whose count has valuation exactly t was 1, 3, 13 for t = 1, 2, 3. The sequence 1, 3, 13 begins the Fubini numbers A000670 (ordered set partitions), whose next term is 75. This is a guess from three data points.
