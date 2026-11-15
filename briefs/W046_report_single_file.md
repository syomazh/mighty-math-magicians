# W046 — Assemble the report: one self-contained `.tex` file and its PDF

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". Deadline pressure: the report is due on Sunday at 12:00; a complete draft is needed within about 90 minutes of your start, so that humans can read it in the morning.

## What this is

The competition requires **one self-contained `.tex` file and the PDF compiled from it** as the report. It is the official record: a panel of five AI models scores it on Correctness, Clarity, Motivation, Interest, Attribution and Novelty, and judges may read it. Read `SUBMISSION_RULES.md` (repository root) first: it lists the requirements and the rubric. Everything the team wants judged must be in this file.

The material exists; your job is to assemble it, not to do new mathematics:

| Material | Where |
|---|---|
| main proof (tree rotations), 13 pages | `paper/main.tex` |
| Frobenius proof (algebra only) | `paper/frobenius_proof.tex` |
| accounting proof | `paper/accounting_proof.tex` |
| lattice-path proof (a guest agent's note) | `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex` |
| status and grade of every claim | `CLAIMS.md` (first tables, then the dated updates; the latest update wins) |
| what is new, what is known, prior work | `FINDINGS.md`, `notes/2026-11-14_path_proof_literature.md`, `notes/2026-11-14_connections_ranked.md` |
| Lean: statements, differences from the written proofs, what is not checked | `lean/README.md` |
| which AI tool did what, how it was checked | `AI_USAGE.md` |
| what was done when | `JOURNAL.md`, `STATE.md` |
| computations and their ranges | `experiments/E*/README.md` |
| bibliographic data | **only** `references/README.md` |
| slides whose content must be covered | `talk/slides.tex`; `talk/NOTES.md`; the second deck is a PDF, `talk/Fuss–Catalan valuations from rotations of trees.pdf` (read its text with the Read tool, pages 1-16) |
| the problem statement | `mathathon_problems.txt`, search "PROBLEM 137" |

## Files you own

`report/report.tex` and what `latexmk` produces next to it (`report/report.pdf`, build files in `report/build/`). `report/NOTES.md` for your own remarks to the orchestrator. Nothing else: change no existing file.

## Hard requirements

1. **One file.** No `\input`, no `\include`, no `.bib`, no `\includegraphics` of files (the readers get text only). Bibliography as `thebibliography` inside the file. Every key picture is described in words (for example a worked example of a rotation class as a list of trees in bracket notation); small TikZ pictures drawn in the file itself are allowed if they compile, but the text must stand without them.
2. **No names of people on the team anywhere except the title block**, and no repository link except there. The title block is: `\title`, `\author`, and one clearly marked block `% ===== TITLE BLOCK (removed before the AI review) =====` … `% ===== END TITLE BLOCK =====` containing placeholders `TEAM MEMBERS: to be filled by the team`, `REPOSITORY: https://github.com/syomazh/mighty-math-magicians`, `COMMIT: to be filled at submission`. In the body write "a faculty member of the team", "a team member", "a second agent session run by a team member". (The ledgers contain first names; do not copy them.)
3. **No new claims and no upgraded claims.** Every mathematical statement comes from the sources above with the status recorded in `CLAIMS.md`. Do not strengthen wording ("we prove" for something that is `computed`, "new" for something that `FINDINGS.md` or the literature note says is known). If two sources disagree, the later entry of `CLAIMS.md` wins; list the disagreement in `report/NOTES.md`.
4. **Never cite from memory.** Every reference comes from `references/README.md` with the data given there; a statement about what a paper contains must be one that the repository's notes already make after opening it. If something you need is not there, leave it out and list it in `report/NOTES.md`.
5. **A status table for every main claim**, with these columns: claim; how it is supported, in the competition's categories (proved in this report, with the section; verified in Lean, with the declaration; checked by computation, with what and over what range; cited; conjecture); whether a human on the team has read and approved the written proof (from `CLAIMS.md`: the main proof C1 to C8 and the lattice-path proof C24 are signed by a faculty member of the team; the accounting proof was read, "looks like it makes sense", not signed; the Frobenius proof has no human reader). Be exact: a proof that only AI systems have checked is said to be so.
6. **A Lean section** that lists each Lean declaration the report relies on, the claim it supports and every difference between the two (from `lean/README.md`, sections "The final statements", the list of differences, "Not checked by Lean", "What one has to trust"). State the definition of "Lean-verified" that the rules give. Mark with `% TODO(orchestrator)` the two things that are changing tonight: the versions (the project is being moved to Lean v4.35.0 and Mathlib v4.35.0, as the rules require) and the lattice-path proof (its divisibility half and the reduction to the minimal words are checked; the count, the residue and exactness are in progress: write the section so that one sentence can be changed).
7. **An AI-use section** (from `AI_USAGE.md`): tools, what for, how the output was checked, and what no human has checked. And a section "Work done during the event": everything in the report was done during the 40 hours; say so and give the order of events briefly.
8. **Attribution, precisely.** What the problem's references already contain (the exact formula by arithmetic and the group action that gives divisibility: Konvalinka; see `FINDINGS.md` and the notes for what exactly), what is prior work for p = 2 (Etherington; the phylogenetics literature), what is known about the path method (Smith 1993; a 2016 MathOverflow answer; `notes/2026-11-14_path_proof_literature.md` has the safe wording), the classical theorems used or reproved (Kummer; Anton, Stickelberger, Hensel; Wilson), the starting point of the Frobenius proof modulo p (as credited in `paper/frobenius_proof.tex`). What the team claims as its contribution is what `FINDINGS.md` says, in those terms.
9. It must **compile**: `cd report && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build report.tex`, then copy `build/report.pdf` to `report/report.pdf`. No undefined references, no missing citations. If a compile takes more than five minutes, stop it and find the cause (a TikZ picture is the usual one); do not wait.

## Structure (adapt if something fits better; keep it readable, length earns nothing)

1. Abstract (a short paragraph: the problem, the result, what was done, how it is supported).
2. The problem, what was known, and what is unsatisfying about it (motivation in the rubric's sense: say what the arithmetic proof does not explain; "it is open" is not a reason).
3. Results at a glance, with the status table.
4. The main proof, in full (from `paper/main.tex`, including its worked examples).
5. Three further proofs done during the event, each with one paragraph on what it adds and how it is supported: the lattice-path proof (full text as an appendix), the Frobenius proof (full text as an appendix), the accounting proof (full text as an appendix).
6. Connections with other fields (from the ranked note and `CLAIMS.md` C23, C25, C26: each item with its status: known in that field, our observation checked by computation, or analogy). Keep it short; include what the slides show.
7. Computations (what, range, where).
8. Lean.
9. Work done during the event; limitations; next steps.
10. AI use; acknowledgements (kinds of help, no names).
11. References. Appendices A, B, C.

Merging the four `.tex` sources: unify the preamble; rename labels with a prefix per part (`main:`, `frob:`, `path:`, `acc:`) so that none collide; keep each part's theorem numbering readable (appendix letters); remove each part's own title, abstract and bibliography and move the bibliography entries into the one list (deduplicated, data from `references/README.md`). Do not change the mathematical text of the proofs except for such mechanical changes and for removing names; if you find an error in a proof, do not fix it: report it in `report/NOTES.md`.

## Report (to the orchestrator)

What is in the file (sections, pages), the compile result, everything left as `% TODO(orchestrator)` or as a placeholder, every place where sources disagreed or where you left something out for lack of a source, and what you did not verify.
