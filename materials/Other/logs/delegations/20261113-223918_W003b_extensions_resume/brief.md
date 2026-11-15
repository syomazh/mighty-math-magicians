# W003b — Finish the extensions numerics (resume after a gateway timeout)

A previous worker was carrying out `briefs/W003_extensions_numerics.md` and was cut off by a gateway timeout. It left, in `experiments/E002_extensions/`: `run.py` (about 14 KB), a short `output.txt`, and scratch files `a_test.txt`, `part_ab_test.txt`, `smoke.txt`. There is no `README.md`.

Finish that brief. Read `briefs/W003_extensions_numerics.md` in full first; all its rules still apply (report failures verbatim, do not alter a check to make it pass).

1. Read the existing `run.py` and judge which of Parts A, B, C, D it covers correctly. Fix and complete it rather than rewriting, unless it is unsalvageable (say so if you rewrite).
2. Priority order if time is short: Part B (weighted numbers, claim C9), Part A (level profiles, claim C10), Part C, Part D.
3. Run it with `uv run python experiments/E002_extensions/run.py > experiments/E002_extensions/output.txt`. Keep the output under about 400 lines: tables and summaries, no per-tree dumps. Delete the scratch files `a_test.txt`, `part_ab_test.txt`, `smoke.txt` and `__pycache__` when done.
4. Write `README.md` (Goal, Hypothesis, Method, Results with tables, Analysis, Next steps). For each of C9, C10, C11 state plainly: supported / refuted / not tested, with the ranges tested. Label every observed pattern as a conjecture.

Work in short steps and save files often. Touch only files under `experiments/E002_extensions/`.
