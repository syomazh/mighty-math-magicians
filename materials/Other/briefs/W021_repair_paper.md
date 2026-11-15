# W021 — Repair `paper/main.tex` after the first review round

Three reviewers attacked `paper/main.tex`. The orchestrator adjudicated their findings in `paper/reviews/ADJUDICATION_round1.md`. Your job is to carry out every accepted repair A1–A14 listed there, exactly, and nothing else.

Read first, in this order: `paper/reviews/ADJUDICATION_round1.md` (binding), `paper/main.tex` (all of it), then for detail the sections "Detailed findings" of `paper/reviews/review_kimi.md`, `review_mistral.md`, `review_muse.md`. Where a reviewer's proposed fix conflicts with the adjudication, the adjudication wins; in particular:

- **A2 (freeness):** do not write "the automorphism fixes every leaf because labels are distinct". Use the order argument spelled out in A2, with each of (i), (ii), (iii) proved.
- **A4 (termination):** derive W(b) = 1 from W(b) ≡ 1 (mod q − 1) and 0 < W(b) ≤ q − 1 when q > 2; treat q = 2 separately as in A5. Do not use a congruence modulo p − 1 for this step.

Rules:

- Change statements only where the adjudication says so (A1). Do not weaken any theorem. Do not introduce Legendre's formula, Kummer's theorem or any valuation of factorials or binomials.
- Every repaired proof must be complete: no "clearly", no "by a similar induction" for anything longer than one line.
- Keep notation and numbering style. Keep the worked examples.
- If while repairing you find a further defect, fix it and report it; if you cannot fix something, mark it with the red `\GAP{...}` macro and list it in `paper/GAPS.md`.
- Compile: `cd paper && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex` (tool notes in `paper/GAPS.md` if MiKTeX stalls). Then copy `paper/build/main.pdf` to `paper/main.pdf`. Check the PDF has no "??" references: grep the `.log` for "undefined".
- Write `paper/CHANGES_round1.md`: a table with one row per item A1–A14 giving the lemma/proposition touched and a two-line description of the change, plus any extra defects you found.

Work in short steps and save often. Touch only `paper/main.tex`, `paper/main.pdf`, `paper/GAPS.md`, `paper/CHANGES_round1.md` and `paper/build/`.
