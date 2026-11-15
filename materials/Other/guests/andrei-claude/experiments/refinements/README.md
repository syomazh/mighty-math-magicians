# refinements: a rotation-invariant statistic, and x-binomials

Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.

**Goal.** Andrei's question: can the symmetry argument give congruences for enumerations by a statistic, or for q-binomial coefficients? (Below the variable is x, since q = p^k is taken.)

**Hypotheses tested.**
1. *Leaf-depth profile* (`depth_refinement.py`). For q = p^k, the number N(l) of q-ary trees with n internal nodes and l_D leaves at depth D is divisible by p^t, and N(l)/p^t ≡ (−1)^t Σ ∏ 1/a(δ, j)! (mod p). The sum is over the ways to place the atoms of a minimal tree: a(δ, j) atoms of height j with root at depth δ of the k-blocked p-ary tree, Σ_δ a(δ, j) = m_j, δ + j ≡ 0 (mod k), Σ a(δ, j) p^(−δ) = 1, and l_D = Σ_j a(kD − j, j) p^j.
2. *Cyclotomic factors* (`cyclotomic.py`, needs sympy). Φ_{p^i}(x) divides the x-binomial [N choose n]_x exactly c_i times, c_i the carry into digit i of n + m = N in base p; the x-Lucas congruence modulo Φ_{p^i}(x); for N = qn+1 the same factors divide the polynomial [N choose n]_x/[N]_x, and the cofactor at x = 1 is ≡ (−1)^t/∏ m_j! (mod p).

**Method.** 1: enumerate q-ary trees by profile with a recursion; compare with the formula. 2: exact polynomial arithmetic.

**Results.** 1: agreement in 29 triples (p, k, n), q ∈ {2, 3, 4, 5, 8, 9}. 2: agreement in 567 triples (p, N, n) with N ≤ 18, p = 2, 3, 5, and in 11 Fuss–Catalan cases. Output: `output.txt`.

**Analysis.** 1 is what the tree proof gives for any statistic that is constant on rotation classes; the formula comes from a cherry collapse with exact depths instead of depths modulo k (carry a → a − p·e_(δ+1) + e_δ, non-empty exactly when Σ a_δ p^(−δ) = 1). That proof is a sketch in JOURNAL.md, not written out. In most tested cases a single profile has N(l)/p^t ≢ 0. 2 is classical (carries in x-binomials: Fray 1967, Knuth–Wilf 1989, known to me from search excerpts only); it is here to show that the carries of the path proof are the factors Φ_{p^i}.

**Not checked.** Statistics that depend on the order of the children (they are not constant on classes). Whether statement 1 is in the literature (weighted Catalan numbers: entries 1, 3, 60 of `references/README.md`).
