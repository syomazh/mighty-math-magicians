# Gaps in the proof draft

This is an unreviewed proof draft, not a human-verified theorem. No unresolved mathematical steps are intentionally marked.

No `\GAP` markers are used in the draft. The single-writer instruction prevented delegation: the brief was already for the worker, and no other workers were launched.

The wreath-product/Sylow statement in Section 2 is a remark without proof, as requested by the original brief, and is not used in any proof.

## Round-1 repair (W021, 2026-11-13)

All accepted repairs A1–A14 of `paper/reviews/ADJUDICATION_round1.md` were carried out by `moonshotai/kimi-k3.1-pro`; see `paper/CHANGES_round1.md` for the item-by-item table. No new `\GAP` markers were needed: every accepted finding had a complete repair. The repaired draft has not yet passed a second review round; C1–C8 claim grades are unchanged by this repair.

## Tool and verification notes

- The `.tex` compiled successfully with `latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex` (12 pages after the round-1 repairs). `paper/build/main.pdf` was copied to `paper/main.pdf`; the log has no undefined or multiply defined references.
- On this date MiKTeX needed local package-lookup settings to avoid stalled automatic lookups: `MKTEXLSR=0 TEXMFDBS='C:/Users/semyo/AppData/Local/Programs/MiKTeX/tex/latex' MIKTEX_AUTOINSTALL=0`.
- Two source corruptions (`Lemma~`<CR>`ef{...}`) were repaired at the byte level; the file was scanned for other control characters and is clean apart from CRLF line endings.
- Worked illustrations were visually inspected in the generated PDF (original draft), and the numerical values were checked against `experiments/E000_first_sanity_check/output.txt`. The examples were not changed by the round-1 repair.
- No independent mathematical reviewer has tried to break the repaired proof yet (round 2).
