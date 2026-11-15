# Problem 137: the exact p-adic valuation of Fuss–Catalan numbers from rotations of trees

Caltech x SAIR Mathathon 2026, Round 1. This repository is the team's whole record: the report, the slides, a Lean project, the computations, and the log of how the work was done.

Written by Claude Fable 5.2 (the project's orchestrating AI agent), 2026-11-15; it replaces a one-line placeholder. Not human-reviewed.

## Where to look

| What | Where |
|---|---|
| **The report** (one self-contained `.tex` file and its PDF; the official record) | `report/report.tex`, `report/report.pdf` |
| **Slides** | `talk/` |
| **Lean project** (three machine-checked proofs of the theorem; what is and is not checked, and every difference from the written proofs) | `lean/`, start with `lean/README.md` |
| Status and grade of every mathematical claim, with its evidence and which tool produced it | `CLAIMS.md` |
| What was found, what is known already, what is new | `FINDINGS.md` |
| Which AI tools were used, for what, and how their output was checked | `AI_USAGE.md` |
| Log of the work, one dated entry per work block | `JOURNAL.md` |
| Computations: one folder each, with goal, method, range and output | `experiments/` |
| The four proof write-ups as separate documents (all are also in the report) | `paper/main.tex`, `paper/frobenius_proof.tex`, `paper/accounting_proof.tex`, `guests/andrei-claude/notes/2026-11-14_path_proof/` |
| Notes: prior work, connections with other fields, reviews | `notes/` |
| Bibliography with what was checked in each source | `references/README.md` |
| Briefs given to AI worker agents, and the automatic record of each run | `briefs/`, `logs/delegations/` |
| The competition's rules as they bind this submission | `SUBMISSION_RULES.md` |

## The result in three sentences

For a prime p and q = p^k, the number of plane q-ary trees with n internal nodes, the Fuss–Catalan number binom(qn, n)/((q − 1)n + 1), is divisible by p^t and not by p^(t+1), where t = (s_p((q − 1)n + 1) − 1)/(p − 1) and s_p is the base-p digit sum. The formula is known (Konvalinka, 2007, by the valuation of factorials); the problem asks for a proof from symmetries of trees. The report gives one, by cyclic rotations of the children of p-ary nodes, together with the residue modulo p^(t+1) and three further proofs found during the event; the status of each claim (proved in the report and read by a person, checked by Lean, checked by computation, or cited) is stated in the report and in `CLAIMS.md`.

## Checking the Lean project

```
cd lean
lake exe cache get
lake build
```

The versions are fixed by `lean/lean-toolchain` and `lean/lake-manifest.json`. The build prints, for every final theorem, the axioms it depends on, and for each of the three proofs a list of the declarations it reaches (`lean/MMM/Axioms.lean`, `lean/MMM/Frob/Axioms.lean`, `lean/MMM/Path/Axioms.lean`). The final statements use only Mathlib's definitions:

- `MMM.problem137_fussCatalan` (rotations of trees), `MMM.Frob.problem137_fussCatalan_frobenius` (algebra in power series), `MMM.Path.problem137_fussCatalan_path` (rotations of blocks of a lattice path): for a prime p, k ≥ 1 and every n, `(p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum`.

## Rerunning a computation

Python with `uv`: `uv run python experiments/<folder>/run.py` from the repository root. Each folder's `README.md` says what is computed and over what range.

## Working here with an AI agent

Have it read [`AGENTS.md`](AGENTS.md) first. In short: run `bash tools/guest_setup.sh <yourname>-<tool>` in your clone, work only in `guests/<yourname>-<tool>/` on the branch `guest/<yourname>-<tool>`, never push to `main`, and push your own branch when done. `CLAUDE.md` and `STATE.md` are for the orchestrating agent.
