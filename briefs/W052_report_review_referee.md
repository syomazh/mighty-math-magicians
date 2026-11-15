# W052 — Referee the report: correctness and clarity of the mathematics

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". You are a **referee**: your job is to find what is wrong or unclear, not to praise.

## What to review

`report/report.tex` (the team's report for the competition; about 70 pages; it compiles to `report/report.pdf`). It will be scored by a panel of five AI models and may be read by judges who are mathematicians. Read as a careful mathematician who has not seen the project. Do not read the project's ledgers or notes before you have formed your own view of a section; you may consult them afterwards to see whether a problem is already known (`CLAIMS.md`, `paper/reviews/`).

Read in full, in this order: the abstract; Section 1 (problem, what was known); Section 2 (results at a glance, status table); **Section 3 (the main proof), line by line**; Section 4 (further proofs, carry budget, and **Section 4.5 "Extensions: other statistics", whose two proofs were written last night and have had no reader at all**); Section 7 (Lean) only for consistency with the rest. Of the appendices read at least the statements and one full proof of your choice in each, and say which.

## What to look for

1. **Errors**: a false statement; a step that does not follow; a definition used before it is given or used in two senses; a hypothesis that is needed and missing (p prime, k ≥ 1, m ≡ 1 mod q − 1, n ≥ 1, …); an example whose numbers are wrong (recompute the worked examples and every number in Section 2 with a short program: `uv run python`).
2. **Gaps**: a step a careful reader cannot fill in a minute; say what is missing.
3. **Clarity**: notation not defined, a symbol that changes meaning between parts (the report merges four write-ups: check that t, m, n, d, N, c, s_p, "minimal", "class", "atom", "skeleton" mean the same everywhere or that the text says where they differ); sentences that are hard to parse; places where a heuristic remark could be taken for a proof.
4. **Consistency**: between the status table (Section 2.3) and the text (a claim called proved must have a proof at the place cited; a claim called conjecture must not be used as a fact); between Section 4.5 and the Lean table; between the abstract and the body; cross-references that point to the wrong place.
5. **Section 4.5 specifically**: check the two short proofs (closed families; level profiles) completely, including the count "the product is the number of q-ary trees with n_i nodes at depth i", the role of n_0 = 1 and n_L = 0, the case of an empty family, and whether "closed under rotation" is meaningful for q = p^k as stated. Test the level-profile statement numerically yourself.

## What you write

One new file, `report/reviews/REFEREE.md` (create the folder), with a header naming Claude Fable 5.2 (a fresh-context referee; brief W052), 2026-11-15, not human-reviewed. Structure:

- Verdict in five lines: is the main theorem proved by the text of Section 3? Is anything false?
- A table of findings, most serious first: severity (WRONG / GAP / UNCLEAR / TYPO), place (section and line number of `report.tex`), what is wrong, a proposed replacement text (LaTeX, ready to paste) wherever you can give one.
- What you checked numerically and how.
- What you did not read.

Change nothing else: not the report, not any other file. No git command that changes anything.

## Report (to the orchestrator)

Your verdict, the number of findings by severity, and the three findings that matter most.
