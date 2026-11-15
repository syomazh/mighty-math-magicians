# W010 — First draft of the talk slides (Beamer)

A 20-minute talk at the Caltech Mathathon, judged on motivation, correctness, interest and clarity. Presenters: a first-year undergraduate and a combinatorics grad student. The audience is mathematicians from all areas.

Read first: `notes/briefing_grad_student/briefing.tex` (authoritative for the mathematics and notation), `STATE.md` (section "Talk outline"), `CLAIMS.md`, `paper/main.tex` (for pictures you can adapt).

Write `talk/slides.tex` (Beamer, aspect ratio 16:9, default theme with light customization, no packages beyond beamer, amsmath, amssymb and tikz). About 16 slides. First line a comment naming your model. Then `talk/NOTES.md`: for each slide, three to five sentences of what to say, and a suggested speaker.

Requirements:

1. Follow the seven-part outline in `STATE.md`. One idea per slide. Few words, large pictures.
2. Draw with TikZ: (a) a small table of C_n with the power of 2 next to the binary expansion of n+1; (b) a q-ary node opening into its p-ary block; (c) a rotation at a node, with symmetric and asymmetric nodes in two colours; (d) the three minimal trees for p = 2, n = 6, with atoms drawn as triangles labelled 1, 2, 4; (e) a cherry collapsing into one atom next to the base-p column addition performing the same carry; (f) one slide contrasting Konvalinka's group (all permutations, orbit sizes are multinomials) with ours (rotations, orbit sizes are powers of p).
3. One running example throughout: p = 2, n = 6, C_6 = 132 = 4·33, m = 7 = 111 in base 2. One slide showing a prime-power case: p = 2, q = 4, n = 4.
4. Status honesty: define a macro `\claimstatus` near the top, currently expanding to the words "candidate proof, under verification", and show it in small type on every slide that states a result. Do not use the word "theorem" for our own statements except through a macro `\ourresult` that currently expands to "Claim", so both can be switched in one place once a human signs.
5. Second-to-last slide: "What else falls out" (weighted numbers, level profiles) marked as conjectural. Last slide: how AI was used, in four bullet points, taken from `JOURNAL.md` and `CLAIMS.md`: which model had the idea, which wrote, which attacked, what humans verified (leave that line as "to be filled in").
6. Compile: `cd talk && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build slides.tex`, then copy `build/slides.pdf` to `talk/slides.pdf`. If MiKTeX stalls on package lookup, see the tool notes in `paper/GAPS.md`. Fix all errors and any overfull slide.

Do not invent results or numbers; every number must appear in the briefing or in `experiments/E000_first_sanity_check/output.txt`. Touch only `talk/slides.tex`, `talk/slides.pdf`, `talk/NOTES.md` and `talk/build/`.
