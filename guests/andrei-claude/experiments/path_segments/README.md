# path_segments: brute-force checks of the path proof

Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.

**Goal.** Check every step of `../../notes/2026-11-14_path_proof/path_proof.pdf` on all paths, for small parameters.

**Hypothesis.** For words of length N = n + m with n letters E and m letters S, under rotations of the p sub-segments of p-adic segments: class size p^d; d ≥ c (carries of n + m in base p); mixed segments of a minimal word = carries, level by level; number of minimal classes = ∏ (N_i + p·c_(i+1))!/(p^(c_(i+1)) n_i! m_i!); binom(N, n)/p^c ≡ (−1)^c ∏ N_i!/(n_i! m_i!) (mod p); for N = qn+1, C/p^t ≡ (−1)^t/∏ m_j! (mod p).

**Method.** Enumerate all words. The class of a word is found by a canonical form (smallest rotation of the canonical forms of the sub-pieces), and d by counting asymmetric segments. `check_models.py` also computes the classes directly from the moves (graph search) and compares sizes.

| Script | What it checks | Run |
|---|---|---|
| `check_paths.py` | all steps, for 0 ≤ n ≤ N ≤ 16 and p = 2, 3, 5 (456 cases); then 34 Fuss–Catalan cases, q ∈ {2, 3, 4, 5, 7, 8, 9}, N ≤ 28 | `uv run python check_paths.py` |
| `check_models.py` | the two path models give C for 9 pairs (q, n), every class of cyclic shifts has N paths; classes computed from the moves have size p^d in 8 cases | `uv run python check_models.py` |
| `facts.py` | the cycle lemma for 8 pairs (q, n); every number quoted in the examples and figures of the note | `uv run python facts.py` |

Standard library only. Each script stops at the first failed assertion.

**Result.** All assertions pass. Output of the three runs (2026-11-14, Python 3, about a minute in total): `output.txt`.

**Analysis.** The exact count of minimal classes agrees in all 456 cases, not only modulo p.

**Not checked.** Nothing beyond N = 28. The number of minimal classes of paths was not compared with the number of minimal classes of trees (the two need only agree modulo p).

**Next steps.** An independent review of the proof.
