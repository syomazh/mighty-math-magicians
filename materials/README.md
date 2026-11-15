# materials

Written by Claude Fable 5.2 (the project's orchestrating AI agent), 2026-11-15. Not human-reviewed.

Everything of the submission that is not the report (`report.tex`, `report.pdf`), the slides (`slides.pdf`) or the Lean project (`lean/`), which are in the root of the repository.

## Proofs

The four proofs as separate documents, each as the AI systems produced it. All four are reproduced in the report, which also says who has read what; the report is the official record.

| Folder | Proof | In the report | Files |
|---|---|---|---|
| `Proofs/main_tree_rotations/` | The main proof: rotations of p-ary trees | Section 3 | `main.tex`, `main.pdf` |
| `Proofs/lattice_paths/` | The proof on lattice paths (Kummer's theorem with its residue, by rotations of blocks of a path) | Appendix A | `path_proof.tex`, `path_proof.pdf`, the figure files it inputs, `gen_figs.py` |
| `Proofs/algebraic_frobenius/` | The algebraic proof (a lift of the Frobenius map on power series) | Appendix B | `frobenius_proof.tex`, `frobenius_proof.pdf` |
| `Proofs/accounting/` | The accounting proof (every node is worth −p) | Appendix C | `accounting_proof.tex`, `accounting_proof.pdf` |

- Which model wrote and revised each file is in the first lines of each `.tex` file.
- The lattice-path files are a copy of the note in `Other/guests/andrei-claude/notes/2026-11-14_path_proof/`, where it was written in a guest session of a team member with Claude.
- **The human-assisted write-up of the main proof**, which the team wants in `Proofs/main_tree_rotations/`, was not in the repository when this layout was made (2026-11-15, 11:04 PT); it is to be added there by the team.
- Reviews of these texts, earlier drafts and the lists of gaps: `Other/paper/`.

## Other

The former root of the repository, unchanged inside. In the order in which a reader may want it:

| Path under `Other/` | What |
|---|---|
| `CLAIMS.md` | ledger of every mathematical claim: grade, evidence, which tool produced it, human sign-off |
| `FINDINGS.md` | what was found, what is known already, what is new |
| `AI_USAGE.md` | which AI tools were used, for what, and how their output was checked (the fullest statement is Section 9 of the report) |
| `JOURNAL.md` | the log of the work, one dated entry per work block |
| `STATE.md`, `MORNING_BRIEF.md`, `SUBMISSION_RULES.md` | working state, the brief for the team on submission day, the rules as they bind the submission |
| `experiments/` | computations, one folder each, with goal, method, range and output |
| `notes/` | notes: prior work, connections with other fields, reviews |
| `references/README.md` | the reference list, with what was checked in each source |
| `paper/` | reviews, lists of gaps and superseded drafts of the written proofs |
| `report_notes/` | notes and AI reviews of the report |
| `talk/`, `syoma_slides/` | the parts of the deck, earlier decks, their sources; `talk/final/` builds the deck that is `slides.pdf` in the root |
| `guests/` | the folders of guest sessions of team members with AI tools |
| `briefs/`, `logs/delegations/` | the briefs given to AI worker agents, and the automatic record of each run |
| `explainer/`, `problem137/` | an interactive explainer; an early script |
| `tools/`, `CLAUDE.md`, `AGENTS.md`, `pyproject.toml`, `uv.lock` | the project's tooling and the instructions for AI agents |
| `mathathon_problems.txt`, `caltech_mathathon_ai_reference.md` | the competition's problem list and reference sheet, as given to the team |

## Paths in older documents

Until 2026-11-15, 11:04 PT, the contents of `Other/` were the root of the repository. Documents written before that name files by their old paths: read `experiments/...`, `notes/...`, `JOURNAL.md` and so on as paths under `materials/Other/`. Exceptions: `report/report.tex` and `report/report.pdf` are `report.tex` and `report.pdf` in the root; `paper/main.tex`, `paper/frobenius_proof.tex` and `paper/accounting_proof.tex` are in `materials/Proofs/`; `lean/` did not move.

## Running things

- A computation: `cd materials/Other && uv run python experiments/<folder>/run.py` (each folder's `README.md` says what is computed and over what range).
- The deck: `cd materials/Other && uv run python talk/final/build_final.py . ../../slides.pdf` stitches the parts in `talk/` and `syoma_slides/` into the deck.
- The report: `latexmk -pdf -outdir=.report_build report.tex` in the root, then copy `.report_build/report.pdf` to `report.pdf`.
