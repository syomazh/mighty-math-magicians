# E001 — independent explicit replication

**Models:** Kimi K3.1 Pro (Moonshot AI), original and resumed worker. The original worker left a partial implementation; this README describes the final retained run, not the early failed outputs.

## Goal

Test the tree-symmetry claims C1–C5, C7 and C8 using explicit objects and explicit rotations, independently of `experiments/E000_first_sanity_check/check.py`.

## Hypothesis

For the small retained cases, explicit \(q\)-ary trees and their local cyclic rotations should have orbit size \(p^{d(T)}\), minimum \(d=t=(s_p(m)-1)/(p-1)\), and the predicted minimal-orbit counts and residues. Labelled cyclic trees should have free prime-to-\(p\)-order actions and the carry–cherry recursion.

## Method

`run.py` enumerates ordered \(q\)-ary trees recursively as nested tuples, enumerates a second \(p\)-ary forest by leaf counts when \(k=1\), and constructs rotation classes by breadth-first search using `rotate`. Asymmetry and atom checks use direct recursive cyclic-equivalence tests, rather than an E000 canonical-form routine. It then tests labelled cyclic trees by explicit depth-compatible label assignments and explicit permutations.

The E000 **source code was not opened**. E000's `output.txt` was read only after the retained replication results had been produced, as required for comparison.

The small final run is intended to be reproducible and fast; it is not the requested full 47-case replication.

## Results

Captured in `output.txt`:

| p | k | n | C_n | orbits | min d | N_min | N_min mod p | C8 exact |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 1 |
| 2 | 1 | 2 | 2 | 1 | 1 | 1 | 1 | 1 |
| 2 | 1 | 3 | 5 | 2 | 0 | 1 | 1 | 1 |
| 2 | 1 | 4 | 14 | 3 | 1 | 1 | 1 | 1 |
| 2 | 1 | 5 | 42 | 6 | 1 | 1 | 1 | 1 |
| 3 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 1 |
| 3 | 1 | 2 | 3 | 1 | 1 | 1 | 1 | 1 |
| 3 | 1 | 3 | 12 | 2 | 1 | 1 | 1 | 1 |
| 5 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 1 |
| 5 | 1 | 2 | 5 | 1 | 1 | 1 | 1 | 1 |
| 7 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 1 |

All implemented core checks above passed, including C1, C2, C3-in-both-directions, C7 and the \(k=1\) C8 exact formula. The histograms are in `output.txt`.

Labelled results:

| p | k | counts | T | non-p-order fixed | p-cycle fixed | reduced T | C5 residue |
|---|---|---|---:|---:|---:|---:|---|
| 2 | 1 | (5,) | 105 | 0 | 15 | 15 | agree |
| 2 | 2 | (2,2) | 0 | 0 | 0 | 0 | agree (degenerate) |
| 3 | 2 | (1,2) | 0 | 0 | not applicable | not applicable | not applicable |
| 2 | 3 | (2,0,0) | 0 | 0 | 0 | 1 | **disagree** |

The two final failures are reproduced here verbatim:

```
FAILURE C5 collapse count (2, 3, (2, 0, 0)): 0 vs 1
FAILURE C5 recursion (2, 3, (2, 0, 0)): 0 vs 1
```

The final output contains 510 recorded checks and 2 failures.

## E000 comparison on retained core cases

Every retained core row agrees with E000's corresponding row in all compared columns `C_n`, `min d`, `#orbits`, and `N_min`. There is no disagreement among these retained cases.

E000 contains additional cases that were not completed here: \(p=2,k=1,n=6,7,8\); \(p=3,k=1,n\ge4\); \(p=5,k=1,n\ge3\); \(p=7,k=1,n\ge2\); and all \(k=2,3\) core cases. Those cannot be called independently replicated by this run.

## Coverage of brief items

1. **Partly checked.** Ordered \(q\)-ary counts and leaf counts are explicit; independent leaf enumeration is present for \(k=1\). A faithful explicit \(q=p^k\)-to-expanded-\(p\)-ary conversion was not completed, so \(k>1\) core cases were removed rather than reported as valid.
2. **Partly checked.** Explicit rotation BFS and invariance are checked for the retained \(k=1\) cases.
3. **Partly checked.** C1 orbit sizes are checked for those retained cases with explicit classes and recursive asymmetric-node tests.
4. **Partly checked.** Minimum \(d=t\) and histograms are recorded for those retained cases.
5. **Partly checked.** The carry-free atom description and its converse are checked for those retained cases; \(k>1\) depth congruences were not completed.
6. **Partly checked.** C7 and \(k=1\) C8 are checked for the retained rows only.
7. **Partly checked.** A small labelled test \((2,1,(5,))\) checks freeness and C5. The requested at-least-7-labelled cases for \(p=2,3\), at-least-9 for \(p=5\), and the full \(k=1,2,3\) grid were not completed. The final \(k=3\) small labelled case reported the two failures above; they were not suppressed.

## Analysis

The retained results are consistent with E000 and with C1–C3/C7/C8 on the small \(k=1\) cases. They do **not** establish the requested broad independent replication. The \(k>1\) conversion failure and the labelled \(k=3\) discrepancy are experiment limitations/failures, not interpreted here as mathematical counterexamples.

The early partial output files `output_first.txt` and `output_smoke2.txt` remain untouched for provenance. `output.txt` is the final retained run's stdout/stderr capture.

## Next steps

- Implement and unit-test a faithful \(p\)-ary expansion for every \(p^k\), then restore all \(k=2,3\) core cases.
- Test nonempty depth-compatible labelled vectors before drawing conclusions from \(T=0\) cases; diagnose the reported \((2,3,(2,0,0))\) reduced-count failure.
- Extend the labelled tests to at least 7 labels for \(p=2,3\) and 9 for \(p=5\), without exhaustive factorial permutation scans where a direct cycle-decomposition test is sufficient.
- Rerun the complete brief and compare all resulting columns against E000.
