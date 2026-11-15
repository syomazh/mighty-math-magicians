# guests/andrei-claude/talk

Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), 2026-11-15. Not human-reviewed.

Slides made in the chat session of 14–15 November (log: `../chat/2026-11-14_15_chat_log.md`). This folder is a guest's copy. Whether any of it goes into the team's `talk/` is the team's decision; nothing here changes `talk/`.

## Files

| File | What |
|---|---|
| `deck_17_slides.pdf` | The whole deck, 17 slides, as it stood on Sunday 2026-11-15 at 12:00 CT. No speaker notes. |
| `slides_proof_second_half_misha.pdf` | Slides 8 to 13 of the deck (Step 5 to "Putting it together"), examples with k = 1. |
| `slides_proof_second_half_misha_k2.pdf` | The same six slides with the examples redone for k = 2 (q = 9). The same file is already in the team's `talk/` (uploaded by a teammate on Sunday). |
| `from_numbers_to_polynomials_slide.pdf` | Slide 16 alone (the outlook slide). |
| `source/` | The deck's source, as exported from the Claude Slides artifact: `deck.json` (order and sections), `deck.css`, `slides/<id>.html` (one slide per file, speaker notes in the `<aside>`), `assets/<id>.png` (the figures and formulas; a slide refers to one as `/_blob/<id>`). |
| `source_k2/slides/` | The five slide files that differ in the k = 2 version (`step5`, `step6`, `step7`, `fixed`, `together`). The sixth slide, `engine`, is unchanged. |
| `figures_src/` | Sources of the figures and formulas made on Sunday, and the count behind the k = 2 examples. |

## Who wrote what

- The slides were written by Claude (Fable 5.2 in every turn the assistant can still see; for the first hours of the session it has only a summary) in a Claude Slides artifact, with the structure and much of the wording given by the user in chat, slide by slide. The chat log has the user's instructions word for word.
- The artifact can be edited by people directly. At least one slide (`context`) contains edits that the assistant did not make. So the deck source is not purely AI-written, and the assistant cannot say for every sentence who typed it.
- The files in `source/` are byte-for-byte copies of the artifact's files at its version `1794755027-fff8`, so they carry no header line of their own; this README is their provenance record.
- No person has signed the slides in this folder as checked.

## Status of what the slides say

- Slides 1 to 13 present the tree proof of the team's paper (claims C1 to C7 of `CLAIMS.md`). This folder adds nothing to their grades.
- **Numbers in the examples** were computed by script:
  - k = 1 examples (q = 3, n = 8, a = (5): 40 trees, 36 moved in 12 orbits) and all k = 2 counts: `figures_src/count_T.py`, output in `figures_src/count_T_output.txt` (proposed claim andrei-claude-11).
  - The outlook slide: `../experiments/refinements/bivariate.py` and `../experiments/refinements/sunday_checks.py` (proposed claims andrei-claude-12 and -13).
- **Outlook slide.** "pᵗ divides every coefficient" follows from Steps 2 and 3 of the proof, because rotations preserve the height and the depth of every leaf. The general residue formula behind "only the minimal trees remain" is checked in 29 cases and its proof is a sketch (andrei-claude-8, -9). The sentence on Gaussian binomials rests on a computer check of the cyclotomic factors (andrei-claude-10) and on search excerpts about the literature; we did not prove it.
- **k = 2 version, slides "Step 7" and "Step 7, continued".** The example a = (6, 1) is not the label vector of a small case of the theorem: the smallest n with q = 9 that gives it is n = 23 (m = 185). The slides use T(6, 1) as a set of labelled trees in its own right. The report (`report/report.tex`, around line 664 at commit 163ddd0) has the same numbers: T(3, 2) = 4, T(0, 3) = 2, T(1, 0) = 1, T(6, 1) = 80, 8 fixed.

## Rebuilding

- A figure: `pdflatex wrapper_example.tex` in `figures_src/` builds the k = 2 orbit figure; to build another one, change the name in its `\input{…}` line to another `fig_*.tex` (all five compile with this wrapper). Then `pdftocairo -png -transp -r 400`. The k = 2 figure bodies are produced by `gen_k2_figs.py`. The formulas `e12` to `e14` compile by themselves.
- The k = 2 slide files refer to three images that are not in the artifact: `2d4e9c24…` is `figures_src/k2_step5.png`, `1b90a821…` is `figures_src/k2_orbit.png`, `eccdf54f…` is `figures_src/k2_fixed.png`.
- The PDFs were rendered from `source/` with a headless browser (1920 × 1080 per slide) in the assistant's session; that script is not included.
- The counts: `uv run python count_T.py` in `figures_src/` (standard library only).
