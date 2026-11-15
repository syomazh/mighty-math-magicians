# W003 — Numerics for the extensions (claims C9, C10, C11) and second-order data

Read `CLAIMS.md`, `notes/2026-11-13_candidate_proof_sketch.md`, `references/README.md`, and pages 3–6 of `references/konvalinka_wcatalan.txt` (weighted numbers, Theorem 5 and its proof; formulas are garbled by text extraction, the README summarizes them).

Write under `experiments/E002_extensions/`: `run.py` (first line a comment naming your model), `output.txt`, `README.md` (Goal, Hypothesis, Method, Results, Analysis, Next steps). Run with `uv run python ...`. You may read `experiments/E000_first_sanity_check/check.py` and reuse its ideas, but write your own file.

Setting: q = p^k, q-ary trees with n internal nodes, m = (q−1)n+1, t = (s_p(m) − 1)/(p − 1). `~` is rotation equivalence on the p-ary refinement (see the sketch). Test (p,k) in {(2,1), (3,1), (5,1), (2,2), (3,2), (2,3)}.

**Part A — level profiles (C10).** The profile of a q-ary tree is (n_0, n_1, …), n_i = number of internal nodes at q-ary depth i.
(a) By enumeration for small n: the number of trees with a given profile is ∏_i binom(q·n_i, n_{i+1}), and `~` preserves the profile.
(b) Using the product formula alone, for all profiles with n ≤ N (N at least 14 for q ≤ 4, as large as feasible otherwise): p^t divides ∏_i binom(q·n_i, n_{i+1}).
(c) For each n list the "tight" profiles (valuation exactly t) with the residue of count/p^t mod p. Check that the residues sum to (−1)^t/∏ m_j! (mod p). Look for a description of the tight profiles in terms of the base-p digits of m and report it as a conjecture with supporting data.

**Part B — weighted numbers (C9).** C_n^(q)(b) = Σ_T ∏_v b(i_v), where i_v is the number of non-right edges on the path from the root to v (the right branch is the last of the q branches). For T and an integer x let w_b(T)(x) = ∏_v b(x + i_v). Konvalinka's hypothesis on b is: b(0) ≡ 1 (mod q) and q^(j+1) divides Δ^j b(x) for all j ≥ 1 and all x. Use b(x) = 1 + q·c_0 + Σ_{j≥1} c_j·q^(j+1)·binom(x, j) with random integers c_j (several random choices, degree up to 3), and also the simple b(x) = 1 + q^2·x.
For each `~`-class O put r_b(O)(x) = (Σ_{T in O} w_b(T)(x)) / |O|. Verify for x = 0..5:
(i) r_b(O)(x) is an integer and r_b(O)(0) ≡ 1 (mod q);
(ii) if the root branches of a tree in O lie in classes O_1,…,O_q then r_b(O)(x) = b(x)·(1/q)·Σ_i r_b(O_i)(x)·∏_{j≠i} r_b(O_j)(x+1);
(iii) C_n^(q)(b) ≡ C_n^(q) (mod p^(t+k)).
Then repeat (i) and (ii) for a smaller group that is not transitive on the q branches (for k = 2: rotations only at the lower level of each block) and report whether they fail, to confirm that transitivity is the property that matters.

**Part C — other closed families (C11), k = 1.** For F = trees of height ≤ h, and F = trees with all leaves at depth ≥ g: report v_p(|F|) against t, and the number of minimal classes in F mod p.

**Part D — second order (exploration).** For each case tabulate N_d (number of classes with d asymmetric nodes) for d = t, t+1, t+2 and C_n^(q)/p^t mod p^2. Look for a formula for N_(t+1) mod p. Report data; label any pattern as a conjecture.

Report every failure verbatim. Do not alter a check to make it pass. Touch only files under `experiments/E002_extensions/`.
