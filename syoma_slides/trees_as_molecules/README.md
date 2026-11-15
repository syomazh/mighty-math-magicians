# Trees as molecules: a chemistry reading of Problem 137

*Written by Claude Fable 5.2 (Claude Code), 2026-11-15. The deck was drafted by Claude Opus 5.5 and revised by Claude Fable 5.2 on the same day. No human and no chemist has reviewed the chemistry.*

A 13-slide deck for the case q = p = 3. Each slide puts a statement of the main proof next to what it means for an alcohol C_nH_(2n+1)OH.

| File | What |
|---|---|
| `trees_as_molecules.pdf` | the slides, one per page (13 pages, 16:9) |
| `trees_as_molecules.html` | the same slides as one self-contained page; open it in a browser (the fonts load from Google Fonts) |
| `source/deck.json` | slide order and sections |
| `source/deck.css` | the shared styles |
| `source/slides/<id>.html` | one file per slide; speaker notes are in the `<aside>` at the end of each |

The HTML page is `source/` concatenated in the order of `deck.json`; the PDF is that page printed by a headless browser.

## Status of what the slides say

- **Proved** (report, human-signed, Lean build on v4.35.0): class size 3^d, d ≥ t, the exact valuation.
- **Cited, read by AI only**: alcohols as rooted trees with a rotation of order 3 at each carbon (references 72, 73 of `references/README.md`); the symmetry number 81 of the tert-butyl radical (reference 11; its published correction was not read).
- **Checked by computation**: rotation classes are the stereoisomers, up to 14 carbons (claim C25 (a)); class size × fixing spins = 3^n (C23 (d)); the items of slide 12 (C25 (c), (e); C23 (c)).
- **Our reading, not a result**: the comparison of Konvalinka's orbits with structural isomers; the resemblance to Pólya's equation (24).

## Open points

- The quotes on slides 4, 7 and 11 were not compared with `report/report.tex` word for word.
- Not confirmed that everything on the slides is in the report, which the submission rules require; the report has a short chemistry passage only.
- "Lopsided carbon" is the deck's word for an asymmetric node of the proof; a chemist's "asymmetric carbon" means something narrower.
