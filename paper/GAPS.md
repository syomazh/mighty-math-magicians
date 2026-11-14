# Gaps in W001 proof draft

This is an unreviewed proof draft, not a human-verified theorem. No unresolved mathematical steps are intentionally marked.

No `\GAP` markers are used in the final draft. The single-writer instruction prevented delegation: the brief was already for the worker, and no other workers were launched.

The wreath-product/Sylow statement in Section 2 is a remark without proof, as requested by the brief, and is not used in any proof.

## Tool and verification notes

- The `.tex` compiled successfully with `latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex` (11 pages).
- On this date MiKTeX needed local package-lookup settings to avoid stalled automatic lookups: `MKTEXLSR=0 TEXMFDBS='C:/Users/semyo/AppData/Local/Programs/MiKTeX/tex/latex' MIKTEX_AUTOINSTALL=0`.
- Worked illustrations were visually inspected in the generated PDF, and the numerical values were checked against `experiments/E000_first_sanity_check/output.txt`.
- No independent mathematical reviewer has tried to break the proof.
