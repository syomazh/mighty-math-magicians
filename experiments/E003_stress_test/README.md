# E003 — Large-scale stress test with a class-counting generating function

Written and run by Claude Fable 5.2 (orchestrator), 2026-11-13 ~23:40 PT. A Kimi worker (W012) had started this task and was stopped to save Open Math OS budget; none of its code is used. Not human-reviewed.

- **Goal.** Test claims C1, C2, C6, C7, C8 far beyond the sizes that can be enumerated, without assuming any of them.
- **Hypothesis.** With F_δ(x, y) = Σ over rotation classes x^(leaves) y^(d), the recursion `F_δ = [δ=0]·x + F_{δ+1}(x^p, y^p) + y·(F_{δ+1}^p − F_{δ+1}(x^p, y^p))/p` holds; evaluating at y = p gives the Fuss–Catalan numbers; the lowest power of y in the coefficient of x^m is t; its coefficient N_min is ≡ (−1)^t/∏ m_j! (mod p); for k = 1 it equals (pt)!/(t!·p^t·∏ m_j!).
- **Method.** `run.py`. Full polynomials in y are kept for every coefficient (packed into one integer each), so nothing is truncated or assumed. Check (a), the total at y = p against binom(qn, n)/((q−1)n+1), tests the recursion and "class size = p^d" together against independent ground truth. Run: `uv run python experiments/E003_stress_test/run.py`.
- **Results.** `output.txt`, `data.csv`. Twelve cases (p, k): p ∈ {2, 3, 5, 7, 11, 13} with k = 1 up to about 400 leaves; (2,2), (3,2), (5,2), (2,3), (3,3), (2,4) up to about 300 leaves. In total 1067 admissible values of m. **Failures: 0 for every check.**
- **Analysis.** The claims hold on every tested instance, including large primes and k up to 4. The class counts for n ≤ 8 agree with E000. This is strong evidence for the statements; it says nothing about whether the written proofs are correct.
- **Limits.** The recursion itself is the orchestrator's; its correctness is supported by check (a) but it was not derived independently by anyone else. p = 2, k = 1 stopped at 389 leaves because of the time limit.
- **Next steps.** `data.csv` holds N_(t+1) and N_(t+2) mod p for a later look at residues modulo p².
