# E011 — exact statements behind the cross-field readings

- **Date:** 2026-11-14, by Claude Fable 5.2 (orchestrator). Not human-reviewed.
- **Belongs to:** `notes/2026-11-14_carry_budget.md` and `notes/2026-11-14_crossfield_analogies.md`.

## Goal

Each analogy with another field (counters and heaps, symmetry numbers in chemistry, knockout brackets, Dwork's exponential) rests on an exact arithmetic or combinatorial statement. This experiment checks those statements, so that the notes can separate "exact" from "analogy".

## Hypotheses and method

`uv run python experiments/E011_crossfield_checks/run.py` (output in `output.txt`):

| Part | Statement | Test |
|---|---|---|
| A | Dwork form: C_n^(q)·m! ≡ (−p)^N (mod p^(N+1)), N = (m−1)/(p−1); equivalently v_p(C) = v_p(π^(m−1)/m!) with π^(p−1) = −p | 565 pairs (q, n), p ≤ 13, k ≤ 4 |
| B | The number of carries made while counting 0, 1, …, m in base p, the number of carries made when the leaf counts are added up along any p-ary tree with m leaves, and v_p(m!) are all equal to (m − s_p(m))/(p−1) | all m < 400 for p = 2, 3, 5, 7; 3,830 random trees |
| C | Every rotation class has at most v_p(m!) symmetric nodes, and some class attains it | all 1,030 classes of small trees (enumeration of E000) |
| D | Z_m(y) = Σ over classes of y^d, with Z_m(p) = C | printed for seven cases |
| E | Example tables: ternary trees (alkyl radicals), knockout brackets | arithmetic identities asserted for every row |

`uv run python experiments/E011_crossfield_checks/excess.py` (output in `excess_output.txt`): part F, the carry-budget identity of claim C19, on every rotation class of p-ary trees with up to 13 (p = 2), 15 (p = 3), 17 (p = 5), 19 (p = 7) leaves, built explicitly as nested tuples: F1 total carries = (m − s_p(m))/(p−1); F2 a symmetric node makes s_p(b) carries; F3 the excess formula; F4 the equality case.

## Results

All parts pass. 1,978 classes in part F.

## Analysis

- Part A is a restatement of lemmas L1 and L2 of the accounting proof (claim C13); it is tested here in the form used in the notes.
- Part F is new evidence for a new argument (C19); it is a consistency check of an identity whose proof is three lines, not a substitute for reading it.
- Nothing here tests the non-mathematical side of an analogy (for example, what chemists mean by a symmetry number). That is checked against sources in `notes/2026-11-14_crossfield_literature.md`.

## Next steps

None planned.
