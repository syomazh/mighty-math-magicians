# E015 — checks behind the ranked connections

Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Not human-reviewed.

**Goal.** Check by computer every exact statement that the note `notes/2026-11-14_connections_ranked.md` attributes to a connection between our method and another field, as far as it can be checked by enumeration or arithmetic.

**Hypothesis.** Each statement below holds in the range tested.

**Method.** `run.py` (standard library only) enumerates plane p-ary trees as nested tuples, computes the rotation class of each tree (minimal rotation of the canonical forms of the children), the number d of asymmetric nodes, and, where labels are needed, the rotation classes of trees with distinctly labelled leaves. Run with

    uv run python experiments/E015_connections_ranked/run.py

**Results (2026-11-14, 19 checks, all PASS, about 15 seconds).** An earlier version of this file said 17 checks when there were 16.

| Check | Statement | Range |
|---|---|---|
| K0 | class size p^d; minimum of d is t; total is the Fuss–Catalan number | p = 2, n ≤ 9; p = 3, n ≤ 6; p = 5, n ≤ 4 |
| K1a | a cyclic p-ary tree with n nodes, m leaves and d asymmetric nodes has p^(n−d) automorphisms; n − d ≤ ν(m) = (m − s_p(m))/(p − 1) = exponent of p in m!, with equality exactly for the minimal trees | same |
| K1b | these automorphisms, as permutations of the m leaves, form a group of order p^(n−d) (computed explicitly from the orbit of the labelled tree under rotations) | 17 classes: p = 2, n ≤ 5; p = 3, n ≤ 3 |
| K1c | m!/(p^ν·∏ m_j!) ≡ (−1)^ν (mod p), and m!/(p^ν·∏ m_j!·∏ (p − 1)^(j·m_j)) is an integer ≡ 1 (mod p) (the number of Sylow p-subgroups of S_m, if the normalizer has the order assumed in the note) | p in {2, 3, 5, 7}, m < 60; formula level, no group is constructed |
| K1d | by brute force: the rotations of nested blocks (blocks from the base-p digits of m) generate a group of order p^ν(m); its normaliser, found by testing every permutation of the m points, has index (p − 1)^(Σ j·m_j)·∏ m_j! over it, so the number of Sylow p-subgroups of S_m is the number of K1c: 3, 15, 45, 315 for p = 2 and m = 4, 5, 6, 7; 10, 70, 1120 for p = 3 and m = 6, 7, 9 | seven pairs (p, m) |
| K2 | rotation classes of ternary trees with n nodes are counted by OEIS A000625 (1, 1, 1, 2, 5, 11, 28, 74); the class sizes 3^d sum to binom(3n, n)/(2n + 1); the smallest class has 3^t trees; the largest value of 3^(n−d) is 3^ν(m) | n ≤ 7 |
| K2b | n = 4 (butyl): 55 = 1 + 9 + 9 + 9 + 27 | |
| K3a | binary trees with m distinctly labelled leaves, up to rotation: (2m − 3)!! of them, an odd number; exchanging two labels fixes a tree exactly when the two leaves form a cherry, and (2m − 5)!! trees are fixed; a shape with σ symmetric nodes has m!/2^σ labellings | m ≤ 7 |
| K3b | p = 3 and 5: (pt)!/(t!·p^t) labelled classes, ≡ (−1)^t (mod p); a cyclic permutation of p labels fixes exactly (p − 1)·L(t − 1) classes, all with these labels as a cherry | p = 3, t ≤ 3; p = 5, t ≤ 2 |
| K4 | among binary trees with m leaves the smallest number of asymmetric nodes is (number of 1 bits of m) − 1 | m ≤ 12 |
| K5 | a counter in base b in which b equal runs merge into one run of the next level: after m insertions the levels hold the base-b digits of m and (m − s_b(m))/(b − 1) merges have happened; for prime b this is the exponent of b in m! | b in {2, 3, 4, 5, 10}, m < 400 |
| K5b | a binomial heap built by m insertions: one tree per 1 bit of m, and m − (number of 1 bits) links | m < 600 |
| K6 | the tree shape of RFC 6962 (split at the largest power of two smaller than n) has (number of 1 bits of n) − 1 asymmetric nodes, the minimum, and its maximal perfect subtrees are the binary digits of n | n < 200 |
| K7 | for m = (q − 1)n + 1, q = p^k: the base-p digits of m folded onto k positions (digit j onto position j mod k) have weight ≡ 1 modulo p^k − 1 | (p, k) in (2,2), (2,3), (3,2), (5,2), (2,4); n < 40 |
| K8 | Domalski and Hearing (1988, Appendix D), numbers copied from the paper: for a group on a benzene ring or a double bond, N(int) = 3^(symmetric nodes of the group's tree), times 2 for the ring (toluene 6, t-butylbenzene 162, propylene 3); for an alkane written as two groups R–R′, 3^sym(R) · 3^sym(R′) · (1, 2 or 4) = N(tot) (methane 12, ethane 18, n-butane 18, 2-methylpropane 81, 2,2-dimethylpropane 972, 2,2-dimethylbutane 243, 2,2,3,3-tetramethylbutane 13122, 2-methylbutane 27). The last factor is listed per molecule, not predicted. **History:** the first version of K8 listed 3 for ethane as a value of the paper; the paper has 9. The value had been typed from the model. Found by an independent agent; the claim was narrowed and the check rewritten (the history is also in the script). | 3 groups, 8 alkanes |
| K8b | for each of the five butyl groups, (number of ordered trees) × 3^(symmetric nodes) = 81; the pairs are (1, 81), (9, 9), (9, 9), (9, 9), (27, 3) | n = 4 |
| K10 | the ordered ternary trees with n nodes, up to rotation at the root only, are counted by OEIS A121179 (by its comment: staggered conformers of alkyls), and its formula a(n) = A001764(n)/3, plus (2/3)·A001764((n − 1)/3) when n ≡ 1 (mod 3), holds | n ≤ 8 |
| K11 | quadtrees (q = 4): the permutations of the four quarters generated by the proof's two levels of binary rotations, with the diagonals kept together, are exactly the 8 symmetries of the square; families of pictures have 2^d members; with 3 cuts 22 = 2 + 4 + 16; the smallest family has 2^t pictures; the number of families is OEIS A398109 (1, 1, 1, 3, 6, 17) | n ≤ 5 cuts |
| K9 | merging binomial queues of sizes n and n′ costs ones(n) + ones(n′) − ones(n + n′), which is the number of carries of n + n′ in binary (Vuillemin 1978, p. 311 or 312; the two agents who opened it disagree on the page); summed over any binary merge tree with m leaves this is m − ones(m) | n, n′ < 200; all binary trees with at most 9 leaves |

Numbers printed and used in figures: for n = 0..7 ternary: (stereoisomers, trees in all, t, number of smallest classes) = (1,1,0,1), (1,1,0,1), (1,3,1,1), (2,12,1,1), (5,55,0,1), (11,273,1,1), (28,1428,1,2), (74,7752,1,1). Knockout formats for m = 1..12 players: 1, 1, 1, 2, 3, 6, 11, 23, 46, 98, 207, 451 (Wedderburn–Etherington numbers); fewest asymmetric nodes 0, 0, 1, 0, 1, 1, 2, 0, 1, 1, 2, 1; number of formats attaining it 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 3, 1.

**Analysis.** The checks confirm the arithmetic and combinatorial content of the candidate connections. They say nothing about whether the other field uses the statement, which is a matter of sources (see the note). K1c is a check of a formula, not of a group computation. K8 shows the limit of the chemical reading: the tree model gives the symmetry number of a group, and the tabulated numbers are for whole molecules. The reviewing agent (section 7 of the note) recomputed with its own code the content of K0, K1a, K1b, K2, K2b, K3a, K3b and K8b, and the numbers 22 = 2 + 4 + 16 and 8 of K11; it did not rerun K1c, K4 to K7, K9 or K10.

**Next steps.** None planned; add a check here whenever the note gains an exact statement.
