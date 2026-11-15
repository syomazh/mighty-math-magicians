# Submission rules and where we stand against them

Written by Claude Fable 5.2 (orchestrator), 2026-11-15, from the Participant Rules and Submission Guidelines that Syoma pasted into the session at about 00:40, and from the Judge Rules and Judge Guidelines read on the competition site at about 00:43 (`https://competition.sair.foundation/competitions/mathathon/judge-rules`). This is a summary in our own words with our status; the official pages are authoritative. Not human-reviewed.

**Deadline: Sunday 2026-11-15, 12:00 PT. After it nothing can be changed, and a missing report gets no review.**

## What must be submitted

| Item | Requirement | Our status (Sunday 00:45) |
|---|---|---|
| Track | choose one of: Algebra/Number Theory, Analysis, Combinatorics, Computation/Applied Math, Geometry | **not chosen (humans).** The problem page lists Combinatorics and Algebra/Number Theory. |
| Report | **one self-contained `.tex` file and its PDF**; appendix and bibliography inside the file; no `\input`, no `.bib` | **exists (updated 08:30):** `report/report.tex`, 84 pages, compiles; read by two independent AI sessions whose findings are applied, and by a consistency pass (`report/reviews/`). **Not yet read by a human.** Title block still has placeholders for the names and the commit hash. |
| Slides | PDF; **everything on the slides must also be in the report** | two decks exist in `talk/`, and a corrected copy of the AI-written one (`talk/slides_v2.pdf`); both were compared with the report (`talk/SLIDES_VS_REPORT.md`: the teammate's deck needs six changes, the AI-written original fifteen). The humans choose. |
| Supplementary materials | optional; inside the submission | this repository (experiments, notes, ledgers) |
| Lean project | optional; a repository; **Lean v4.35.0 and Mathlib v4.35.0**; an automated check builds it at the deadline and its result overrides the report | **compliant since 01:29:** `lean/` is on Lean v4.35.0 and Mathlib v4.35.0 (`lean-toolchain`, `lakefile.toml`, `lake-manifest.json`); a fresh clone builds from scratch (03:41: 3279 jobs, no `sorry`, standard axioms only); after the files of the accounting proof were added, the full build passed at 08:25 (3292 jobs; a fresh clone of that state built from scratch, finished 09:02) and, after one more file, at 09:13 (3316 jobs; a fresh clone of that final state built from scratch, finished 09:31). |
| Submission form | one ZIP **or** one GitHub link with the **full commit hash**; any team member can submit, replace or withdraw before the deadline | repository is public; **finalized a fourth time at 11:10, in the new layout, and a fifth time at 11:17: then a sixth time at 11:23: commit `445915fe152d73ff17b3306a2d3422dd3847c23e`** (see the top of `MORNING_BRIEF.md`; it changes if the report or `lean/` changes again) |

## Requirements on the report (each is checked by a panel of five AI models)

1. **Title block only:** names, affiliations, repository link and commit hash go only in the title block (it is removed before the AI review). **No names in the body.**
2. **Text, not images:** every key figure described in words; links are pointers, not content.
3. **Work done during the event** must be distinguishable from prior work.
4. **Status of every main claim:** proved in the report / verified in Lean / checked by computation (what, over what range) / cited / conjecture. Presenting an unproved claim as proved costs Correctness; an honest conjecture costs nothing.
5. **AI use:** which tools, for what, how their output was checked. The team must be able to explain everything submitted.
6. **Sources:** every source and kind of help credited; if an argument follows a known one, say so.
7. **Lean:** list each Lean declaration the report relies on, the claim it supports, and every difference between the two. "Lean-verified" means: the project builds (on v4.35.0), the declaration and everything it uses have no `sorry` and only the axioms `propext`, `Classical.choice`, `Quot.sound`, and the statement says what the report claims. `native_decide` does not count. A claim with a `sorry` behind it is "Lean-conditional".
8. If the problem page shows an official Lean statement and we claim its main theorem, we must prove that statement unchanged. **The public page of Problem 137 shows none** (read at about 00:44 without signing in; a team member who is signed in should confirm).
9. Length earns nothing. Everything we want judged must be in the report, including everything on the slides.

## Integrity (violations go to the judges, up to disqualification)

- presenting known work as our own;
- calling a claim Lean-verified when it fails the checks, or hiding a mismatch between a formal statement and its claim.

Consequences for us: the report says for each proof what is known (Konvalinka's action and divisibility; the exact formula by arithmetic; Etherington for p = 2; the path method of Smith and of Wildon; Kummer; Anton, Stickelberger, Hensel), and lists the differences between the Lean proofs and the written ones (`lean/README.md`).

## Presentation and judging

- 20 minutes at most, then up to 10 minutes of questions; 2 to 5 judges, who see only the slides before scoring and may read the report afterwards. Session, time and room are announced on the platform.
- Judges score **Correctness, Clarity, Motivation, Interest**, 1 to 5 each. The AI panel scores the report on the same four and on **Attribution** and **Novelty**.
- What the guidelines stress: define every object; convey uncertainty truthfully; say what is unsatisfying about the old proof (not "it is an open problem"); show creative work done during the event. Lean, AI use and length earn nothing by themselves; Lean is evidence for Correctness only for what it verifies. Honestly labelled partial results are not penalized.
- Questions to expect: definitions; the key step; what is new and what is known; what the AI did and whether we understand it; how sure we are. (`talk/QA.md` has prepared answers.)
- Three of four places on Problem 137 are taken (seen on the problem page), so other teams present the same problem and the judges are told so.

## Open decisions for the humans

1. The track.
2. Which deck is presented (then the report is checked against it).
3. Who submits on the platform, and when (the commit hash must be the final one).
4. Names and affiliations for the title block.
