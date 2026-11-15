# W002 — Independent replication of the core claims by explicit enumeration

Goal: test claims C1–C5, C7, C8 of `CLAIMS.md` with code written independently of `experiments/E000_first_sanity_check/check.py`. **Do not open that file until your own code has produced results**; afterwards compare your numbers with its `output.txt`. E000 used canonical forms and recursive counting; you must use explicit objects and explicit moves.

Read: `CLAIMS.md`, `notes/2026-11-13_candidate_proof_sketch.md`.

Write everything under `experiments/E001_independent_replication/`: `run.py` (first line a comment naming your model), `output.txt` (captured stdout), `README.md` with sections Goal, Hypothesis, Method, Results (tables), Analysis, Next steps. Run with `uv run python experiments/E001_independent_replication/run.py`.

Cases: (p,k) in {(2,1), (3,1), (5,1), (7,1), (2,2), (3,2), (2,3)}, n from 1 up to as large as finishes within about 10 minutes of total runtime.

1. Enumerate all q-ary trees (q = p^k) with n internal nodes as explicit nested tuples; check the count against binom(qn, n)/((q−1)n+1). Convert each to a p-ary tree by expanding every q-ary node into a complete p-ary tree of height k (branches left to right).
2. Compute the classes of `~` explicitly. Generators: "rotate the p children of one node of the p-ary tree by one step". Use BFS or union–find on the set of all trees. Check that the generators never leave the set of k-blocked trees.
3. C1: every class has size p^d, where d is the number of asymmetric nodes and "asymmetric" is decided with the classes you computed, not with a canonical-form shortcut.
4. C2: the minimum of d is t = (s_p(m) − 1)/(p − 1). Record the histogram of d for every case.
5. C3: for each class with d = t take a representative and decompose it into its maximal complete subtrees ("atoms") and the skeleton above them. Verify: no symmetric node above the atoms; the multiset of atom heights matches the base-p digits of m (m_j atoms of height j); every atom of height j is rooted at p-ary depth ≡ −j (mod k); at each skeleton node the leaf counts of the p subtrees add without carries. Verify the converse on all trees: a tree matching this description has d = t.
6. C7 and C8: N_min (number of classes with d = t) satisfies N_min ≡ (−1)^t · (∏ m_j!)^(−1) (mod p); for k = 1, N_min = (pt)!/(t!·p^t·∏ m_j!) exactly.
7. C4 and C5 with explicit labelled trees. For k in {1,2,3} and small label sets (as many labels as feasible; at least 7 for p = 2, 7 for p = 3, 9 for p = 5), enumerate all cyclic p-ary trees with distinctly labelled leaves, each label having a class in Z/k and sitting at depth ≡ −class (mod k). Represent a cyclic tree by a canonical object (for example the lexicographically least rotation at every node). Apply the label permutation σ = (ℓ_1 ℓ_2 … ℓ_p) on p labels of one class explicitly and find its fixed trees. Verify: the fixed trees are exactly those in which ℓ_1,…,ℓ_p are the p children of one node; there are (p−1)·T(a − p·e_c + e_{c+1}) of them; T(a) ≡ −T(a − p·e_c + e_{c+1}) (mod p). Verify freeness: no label permutation of order prime to p, other than the identity, fixes a labelled tree.

Report every failure verbatim. Do not alter a check to make it pass. If a claim is ambiguous, state the interpretation you tested. Touch only files under `experiments/E001_independent_replication/`.
