# W005c — Get the explainer working with a reduced fifth section

Two previous workers built `explainer/index.html`, `explainer/logic.js` and `explainer/selftest.mjs` following `briefs/W005_explainer.md`. The counting logic reproduces all 47 rows of `experiments/E000_first_sanity_check/output.txt`, but: the copy of the logic inlined in `index.html` is out of date (selftest reports "inline logic copy differs from logic.js"), and the last worker got stuck trying to construct trees for the carry/cherry section and left `logic.js` in a half-edited state.

Goal: a page that works, today. Scope is reduced.

1. Read `briefs/W005_explainer.md` for the intent. Inspect `logic.js`; remove or repair any half-finished code so that the module loads and the 47-row check passes. Remove carry-construction tests that cannot be made to pass quickly.
2. **Section 5 is simplified.** Do not construct fixed trees. Instead show the carry process on the class vector only: start from a = (a_0, …, a_(k−1)) built from the base-p digits of m; a "carry" button picks a class c with a_c ≥ p, replaces p atoms of class c by one atom of class c+1 (indices mod k), flips a displayed sign, and animates p chips merging into one chip in the next column (the ring of k columns drawn as a circle when k > 1). Stop at a single atom of class 0 and show "t carries, sign (−1)^t". Beside it draw one fixed illustrative picture (static SVG) of a cherry of p leaves collapsing into one leaf.
3. Sections 1–4 must work as specified in the original brief. Check by running the page's non-DOM functions under Node.
4. Re-inline `logic.js` into `index.html` between the markers so `node explainer/selftest.mjs` prints success. Delete `explainer/.tmp/` if present.
5. Keep the footer "Candidate argument, not yet verified by the team".

In your final summary say, section by section, what works and what you could not test without a browser. **Do not end your turn while the selftest fails.** Work in short steps and save often. Touch only files under `explainer/`.
