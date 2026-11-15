# W055 — Last consistency pass over the report

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## Why

`report/report.tex` (77 pages) was assembled last night by one AI session and then edited by four others and by the orchestrator, each in a few places. Every such edit can leave a sentence elsewhere that no longer agrees. The report is the team's official record and is scored by a panel of AI models; a contradiction between two of its own sentences costs Correctness. Read `SUBMISSION_RULES.md` first.

## What to do

Read the whole report once, from the first line to the end of the bibliography (the appendices: read the text between the proofs and the status paragraphs; the proofs themselves were refereed and are not your subject). Then look for:

1. **Contradictions between two places of the report**: counts (how many proofs are checked by Lean, how many audits, how many reviewers, numbers of cases, numbers of pages or jobs), statuses (the same claim called proved in one place and conjecture or "not checked" in another; "no human has read" against "a faculty member read"), dates and times, names of files and declarations, section references that point to the wrong section, "below"/"above" that are no longer true.
2. **Stale sentences**: anything that describes as future or in progress what another place reports as done ("is being", "will be", "in progress", "not yet", "planned", "next steps"), or as done what is not.
3. **Disagreement with the record**: compare the status table (Section 2.3), the abstract, "The result on one page", Section 7 (Lean) and Section 9 (use of AI) with `CLAIMS.md` (the latest entry for each claim wins; read the updates of 2026-11-15 in particular), `lean/README.md`, `lean/AUDIT3.md` (with its last section "What was done after the audit") and `AI_USAGE.md`. The facts as of now: three proofs of the theorem are checked by Lean on Lean v4.35.0 with Mathlib v4.35.0, a fresh clone was built from scratch at 03:41 on 15 November (3279 jobs); the algebraic proof's Lean file was rewritten at 03:00 to remove a dependency on Kummer's theorem inside Mathlib; C8, C10, C11, C19, C27, C28 are checked by Lean; C29 (the converse in Section 2.2) is proved in the report and not in Lean; C9 and C17 are conjectures; the main proof was looked through by a faculty member of the team and judged good, the lattice-path proof was read and verified, the accounting proof was read and not signed, the algebraic proof and all Lean files have no human reader; no person has read the report.
4. **The rules**: team members' names, user names or the repository link anywhere outside the marked title block (search the `.tex` including comments, and the text of the PDF); `\input`, `\include`, `.bib`, external image files; undefined references; `TODO` comments that are no longer true.
5. **Every `\lean{…}` name**: check that the declaration exists in `lean/MMM/` (grep is enough; do not compile).

## What you may change

You may edit `report/report.tex` for items of kinds 1, 2, 4 and 5 **when the right text is determined by the record** (a count, a status word, a stale tense, a wrong reference, a wrong file name). Mark each change with a comment line before it: `% Consistency pass 2026-11-15 (brief W055): <what was changed>`. Do not change any mathematical statement or proof, the title block, or the bracketed notes inside Section 3 and the appendices. Do not add claims. When the right text is a judgment (how to word a claim, whether to keep a paragraph), do not change it: list it.

After editing: `cd report && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build report.tex`, copy `build/report.pdf` to `report/report.pdf`; no undefined references. If a compile takes more than five minutes, stop it and find the cause.

Change nothing else. No git command that changes anything.

## What you write

`report/reviews/CONSISTENCY.md` (new), with a header naming Claude Fable 5.2 (a fresh-context agent; brief W055), 2026-11-15, not human-reviewed: every finding with its place (a phrase to search for), what it contradicts, and either "changed to: …" or "not changed, for the orchestrator: …". At the end: the compile result and the page count.

## Report (to the orchestrator)

The number of findings, how many you changed, and the ones you left for a decision.
