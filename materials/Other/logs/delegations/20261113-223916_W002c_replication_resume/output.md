Completed the resume task under `experiments/E001_independent_replication/`:

- Reworked `run.py` into a smaller explicit-tree replication.
- Captured final results in `output.txt`.
- Added `README.md` with methods, tables, E000 comparison, coverage, failures, and next steps.
- Retained \(k=1\) core cases agree with E000 on `C_n`, `min d`, `#orbits`, and `N_min`; implemented C1/C2/C3/C7/C8 checks passed.
- Preserved two labelled-case failures verbatim:
  - `C5 collapse count (2, 3, (2, 0, 0)): 0 vs 1`
  - `C5 recursion (2, 3, (2, 0, 0)): 0 vs 1`

Not completed: faithful \(k>1\) expansion and core replication, larger labelled cases, and the full requested case grid. E000 source code was not read; only its output was compared afterward. No commit was made.
