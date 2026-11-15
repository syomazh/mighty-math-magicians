# Problem 137: the exact p-adic valuation of Fuss–Catalan numbers from rotations of trees

Caltech x SAIR Mathathon 2026, Round 1. Team Mighty Math Magicians.

Written by Claude Fable 5.2 (the project's orchestrating AI agent), 2026-11-15, when the repository was put into the layout that the team asked for. Not human-reviewed.

## What is here

| What | Where |
|---|---|
| **The report**: one self-contained `.tex` file and its PDF; the official record | `report.tex`, `report.pdf` |
| **The slides** of the talk | `slides.pdf` |
| **The Lean project** (Lean v4.35.0, Mathlib v4.35.0): what is checked, and every difference from the written proofs | `lean/`, start with `lean/README.md` |
| **The four proofs** as separate documents, as the AI systems produced them (all four are also in the report) | `materials/Proofs/` |
| **Everything else**: the ledger of claims, the log of the work, the computations, notes, reviews, the parts of the deck and their sources, the guests' folders, the briefs given to AI workers and the record of each run | `materials/Other/`, start with `materials/README.md` |

## The result in three sentences

For a prime p and q = p^k, the number of plane q-ary trees with n internal nodes, the Fuss–Catalan number binom(qn, n)/((q − 1)n + 1), is divisible by p^t and not by p^(t+1), where t = (s_p((q − 1)n + 1) − 1)/(p − 1) and s_p is the base-p digit sum. The formula is known (Konvalinka, 2007, by the valuation of factorials); the problem asks for a proof from symmetries of trees. The report gives one, by cyclic rotations of the children of p-ary nodes, together with the residue modulo p^(t+1) and three further proofs found during the event; the status of each claim (proved in the report and read by a person, checked by Lean, checked by computation, or cited) is stated in the report.

## Checking the Lean project

```
cd lean
lake exe cache get
lake build
```

The versions are fixed by `lean/lean-toolchain` and `lean/lake-manifest.json`. The build prints, for every final theorem, the axioms it depends on, and for each proof a list of the declarations it reaches. The final statements use only Mathlib's definitions; the first of them is `MMM.problem137_fussCatalan`: for a prime p, k ≥ 1 and every n,
`(p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum`.

## A note on paths

Until 2026-11-15, 11:04 PT, the folders now under `materials/Other/` were in the root. Documents written before that (the log, the ledgers, notes, `lean/README.md`, the appendices of the report) name files by their old paths: read `experiments/...`, `notes/...`, `guests/...`, `talk/...`, `JOURNAL.md` and so on as `materials/Other/experiments/...` and so on. Two exceptions: `report/report.tex` and `report/report.pdf` are now `report.tex` and `report.pdf` in the root, and `paper/main.tex`, `paper/frobenius_proof.tex`, `paper/accounting_proof.tex` are now in `materials/Proofs/`.
