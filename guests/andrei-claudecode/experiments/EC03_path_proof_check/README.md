# EC03 — an independent check of the proof on lattice paths (claim C24)

Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code, started by Andrei, 2026-11-14. Not human-reviewed.

**Goal.** Test the statements of C24 (`CLAIMS.md`; proof in `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.pdf`) with a program that shares no logic with the author's scripts.

**Hypothesis.** For words of length N with n letters E and m letters S, under rotations of the p sub-pieces of the p-adic segments of the positions: every class has p^d words with d ≥ c, the number of carries of n + m in base p; the number of classes with exactly p^c words is ∏ (N_i + p·c_(i+1))!/(p^(c_(i+1))·n_i!·m_i!); binom(N, n)/p^c ≡ (−1)^c ∏ N_i!/(n_i!·m_i!) (mod p); and for N = qn + 1 this gives the valuation t and the residue (−1)^t/∏ m_j! of the Fuss–Catalan number.

**Method.** `python3 guests/andrei-claudecode/experiments/EC03_path_proof_check/run.py` from the repository root (standard library only, about 4 seconds; system Python 3.13.7, because `uv` is not installed on this machine). The moves are built as permutations of the positions and the classes are found by a graph search from the moves. The program has no canonical form and does not know what an asymmetric segment is: it only measures class sizes and compares them with the formulas. The author's `check_paths.py` works the other way round (canonical forms, d counted from asymmetric segments); I had read its README and stored output, not its code.

**Result (2 checks, both pass).** `output.txt`.

| Part | Statement | Cases | Result |
|---|---|---|---|
| A | Class sizes are powers of p, at least p^c; the number of classes of size p^c equals the product exactly; binom(N, n)/p^c has the stated residue, which is not 0. | 328 triples (N, n, p): p = 2 and 3 with N ≤ 14, p = 5 with N ≤ 12, all 0 ≤ n ≤ N | pass |
| B | For N = qn + 1: c = t, binom(N, n) = N·C, N ≡ 1 (mod p), the smallest class has p^t words, C/p^t ≡ (−1)^t/∏ m_j! (mod p). | 26 pairs (q, n), q ∈ {2, 3, 4, 5, 8, 9}, N ≤ 19 | pass |

**Analysis.** The numbers agree with the two examples of the note (q = 3, n = 3: one smallest class; q = 9, n = 2: four). The range is smaller than the author's (N ≤ 16 and N ≤ 28 there), because a graph search is slower than a canonical form; what it adds is independence of method, not range.

**Not checked.** The intermediate lemmas of the note (atoms are digits; one mixed segment for each carry) are not tested here, only their consequence, the count. Nothing beyond N = 19.

**Next steps.** None planned.
