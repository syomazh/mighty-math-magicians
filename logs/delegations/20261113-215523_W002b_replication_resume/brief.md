# W002b — Finish the independent replication (resume after a gateway timeout)

A previous worker was carrying out `briefs/W002_independent_replication.md` and was cut off by a gateway timeout after about 39 minutes. It left, in `experiments/E001_independent_replication/`: `run.py` (about 25 KB, last modified 21:43), `output_first.txt` and `output_smoke2.txt` (early partial outputs). There is no `output.txt` and no `README.md` yet.

Your task: finish that brief. Read `briefs/W002_independent_replication.md` in full first; all of its rules still apply (in particular: do not open `experiments/E000_first_sanity_check/check.py` until your own results exist, do not alter a check to make it pass, report failures verbatim).

1. Read the existing `run.py`. Decide whether it is sound and covers items 1–7 of the brief; fix or complete it rather than rewriting from scratch, unless it is unsalvageable (say so if you rewrite).
2. Run it with `uv run python experiments/E001_independent_replication/run.py`, capturing stdout to `experiments/E001_independent_replication/output.txt`. Keep total runtime near 10 minutes by limiting n. Keep the output file under about 300 lines (summaries and tables, not per-tree dumps).
3. Compare your numbers with `experiments/E000_first_sanity_check/output.txt` (columns C_n, min d, #orbits, N_min) and state every agreement or disagreement.
4. Write `README.md` (Goal, Hypothesis, Method, Results with tables, Analysis, Next steps), naming both models that worked on the code if you know yours; say plainly which of items 1–7 were fully checked, partly checked, or not checked.

Work in short steps and save files often, so that nothing is lost if the connection drops again. Touch only files under `experiments/E001_independent_replication/`.
