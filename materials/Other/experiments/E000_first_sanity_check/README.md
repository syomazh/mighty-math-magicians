# E000 — First sanity check of the candidate proof

Written and run by Claude Fable 5.2, 2026-11-13 ~20:40 PT. Not human-reviewed.

- **Goal.** Find out quickly whether the candidate proof strategy (`notes/2026-11-13_candidate_proof_sketch.md`) survives brute force before building a plan around it.
- **Hypothesis.** Claims C1–C5 and C7 of `CLAIMS.md`.
- **Method.** `check.py`. Classes of q-ary trees under rotation equivalence are built by canonical forms (least rotation at every p-ary node) with exact tree counts per class. Labelled depth-constrained cyclic trees are counted by an exact rational recursion. Run: `uv run python experiments/E000_first_sanity_check/check.py`.
- **Results.** `output.txt`. 47 cases (q, n) with q in {2, 3, 5, 7, 4, 9, 8}; 307 carry-recursion cases. Every check passes: class size = p^d, min d = t, number of minimal classes = skeleton count, residue (−1)^t/∏ m_j! mod p, carry recursion.
- **Analysis.** The strategy is numerically sound in this range. This is evidence for the statements, not for the proof.
- **Limits.** Small n only (at most 11 for q = 2, 5 for q = 8, 9). The same author wrote the claims and the test; E001 is an independent replication by another model.
- **Next steps.** E001 (independent replication), written proof (W001), extensions (E002).
