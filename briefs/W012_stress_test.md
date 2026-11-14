# W012 — Large-scale stress test with a class-counting generating function (experiment E003)

Read first: `CLAIMS.md`, `notes/briefing_grad_student/briefing.tex`, `experiments/E000_first_sanity_check/output.txt`.

Setting: p prime, q = p^k. Trees are p-ary; a q-ary tree is a p-ary tree whose leaves all have depth ≡ 0 (mod k). `~` = rotation equivalence; d = number of asymmetric nodes; a class with d asymmetric nodes contains p^d trees.

**The recursion to implement.** For δ in Z/k let F_δ(x, y) = Σ x^(number of leaves)·y^(d), summed over `~`-classes of p-ary trees whose root sits at depth δ and whose leaves all sit at absolute depth ≡ 0 (mod k). A class is a leaf (allowed only when δ ≡ 0), or a constant cyclic word of p copies of one class at depth δ+1 (symmetric root), or a non-constant cyclic word (asymmetric root, counted up to rotation). Hence

    F_δ(x, y) = [δ ≡ 0]·x + F_{δ+1}(x^p, y^p) + y·( F_{δ+1}(x, y)^p − F_{δ+1}(x^p, y^p) ) / p .

First derive this yourself and say in the README whether you agree with it; if you find it wrong, stop and explain. Then:

1. **Validate** against every row of `experiments/E000_first_sanity_check/output.txt`: number of classes (set y = 1), min d, N_min (number of classes with d = min), for the coefficient of x^m, m = (q−1)n+1.
2. **Consistency:** the coefficient of x^m in F_0(x, p) must equal the Fuss–Catalan number binom(qn, n)/((q−1)n+1), and coefficients of x^m with m ≢ 1 (mod q−1) must vanish.
3. **Scale up.** Truncated power series in x up to M leaves, exact integer arithmetic. Reach M as large as possible within about 20 minutes of total runtime (target: M ≥ 300 for p = 2, k = 1; do what is feasible elsewhere). Cases: p in {2, 3, 5, 7, 11, 13} with k = 1; p in {2, 3, 5} with k = 2; p in {2, 3} with k = 3; p = 2 with k = 4. To go far it is enough to keep, for each m, only the terms y^d with d ≤ t(m) + 2: argue in the README why truncating higher powers of y is safe for what is checked, or do not truncate.
4. For every admissible m ≤ M check: (i) min d = t = (s_p(m) − 1)/(p − 1); (ii) N_min ≢ 0 (mod p) and N_min ≡ (−1)^t·(∏ m_j!)^(−1) (mod p), m_j the base-p digits of m; (iii) for k = 1, N_min = (pt)!/(t!·p^t·∏ m_j!) exactly.
5. Record N_(t+1) and N_(t+2) for every m (CSV file) for later study.

Write under `experiments/E003_stress_test/`: `run.py` (first line a comment naming your model), `output.txt` (summary table per (p,k): M reached, number of m tested, failures of each check, largest m), `data.csv`, `README.md` (Goal, Hypothesis, Method, Results, Analysis, Next steps). Run with `uv run python`. Report every failure verbatim; do not alter a check to make it pass. Work in short steps and save often. Touch only files under `experiments/E003_stress_test/`.
