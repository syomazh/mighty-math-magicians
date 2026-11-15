# W054 — Check the two slide decks against the report

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". This is a check: you change nothing that exists.

## Why

The competition's rules say: **everything on the slides must also be in the report**, and what is only in the presentation is judged by the human judges only. The team has two decks and will choose one in the morning. They need, for each deck, a list of what is on a slide and not in the report, and of what on a slide disagrees with the report or with the project's record. Read `SUBMISSION_RULES.md` first.

## What to compare

- The report: `report/report.tex` (PDF `report/report.pdf`, 77 pages; page 2 is a one-page summary; Section 2.3 is the status table; Section 5 the connections; Section 9 the use of AI).
- Deck A, a teammate's deck, a PDF without source: `talk/Fuss–Catalan valuations from rotations of trees.pdf` (16 slides; read the pages with the Read tool, as text and as images).
- Deck B, written by an AI system: `talk/slides.tex` with `talk/slides.pdf` and `talk/figures/`. The working copy has an uncommitted extra slide "How the AI team worked" (also in `syoma_slides/`); include it, and say that it is uncommitted.
- The record, for disagreements: `CLAIMS.md` (latest entries win), `notes/2026-11-15_review_rotors_and_guest_notes.md` section 8 (sentences about chemistry that are safe and that are not), `report/NOTES.md` (points the report's assembler already found in the decks), `MORNING_BRIEF.md` item 3.

## What to do

For each deck, slide by slide:
1. List every mathematical statement, number, example, picture and attribution on the slide.
2. For each: where it is in the report (section, and a phrase to search for), or **"not in the report"**.
3. Whether it agrees with the report and the record. Flag in particular: a claim stated as a theorem that the report lists as conjecture or as checked by computation only; "new" or "first" for something the report says is known (Section 1.4); an "if and only if" of which one direction is unproved; citations that are not in the report's bibliography; chemistry sentences on the "do not say" list; statements about who checked what (the workflow slide) against Section 9 of the report and `AI_USAGE.md`; numbers that differ.
4. What the report now has that neither deck mentions and that a speaker might want one sentence for (three Lean-checked proofs on the required version; the level profiles and the invariant weights of Section 4.5; the audit that removed a hidden dependency on Kummer's theorem).

Recompute any number on a slide that you can (`uv run python`, scripts in your scratchpad).

## What you write

One new file, `talk/SLIDES_VS_REPORT.md`, with a header naming Claude Fable 5.2 (a fresh-context agent; brief W054), 2026-11-15, not human-reviewed. For each deck: a five-line verdict (can it be presented as it is under the rule?); a table slide by slide; then two short lists: **"must change before presenting"** (wrong, or contradicting the report) and **"add to the report or drop from the slide"** (on the slide, not in the report), each item with the smallest fix. At the end: for each item of the second list that is true and supported by the repository, the sentence (LaTeX, ready to paste, with the section it belongs to) that would put it into the report; mark anything that needs a human decision. No names of team members in the file (say "deck A", "the teammate's deck").

Change nothing else: not the decks, not the report, no other file. No git command that changes anything.

## Report (to the orchestrator)

For each deck: the verdict, the number of items in each of the two lists, and the three most important items.
