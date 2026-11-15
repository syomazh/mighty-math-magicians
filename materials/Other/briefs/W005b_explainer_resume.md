# W005b — Finish the interactive explainer (resume after a connection error)

A previous worker was carrying out `briefs/W005_explainer.md` and was cut off. It left, in `explainer/`: `index.html` (about 47 KB), `logic.js`, `selftest.mjs`, and a scratch folder `.tmp/`. Right now `node explainer/selftest.mjs` crashes at import time.

Finish that brief. Read `briefs/W005_explainer.md` in full first; all its requirements still apply.

1. Make `node explainer/selftest.mjs` pass: the logic in `logic.js` must reproduce, for every row of `experiments/E000_first_sanity_check/output.txt`, the values C_n, min d, #orbits and N_min, and the copy inlined in `index.html` between `/* LOGIC-BEGIN */` and `/* LOGIC-END */` must be identical to `logic.js`.
2. Go through the five required sections of the brief one by one and check that each exists and works in `index.html`; implement what is missing. Check the page for JavaScript errors by running its script logic under Node where possible (for example extract the non-DOM functions and call them).
3. Keep the footer line "Candidate argument, not yet verified by the team" and do not call anything a theorem.
4. Delete `explainer/.tmp/` when done.
5. In your final summary list, section by section, what works, what is partial, and what you could not test without a browser.

Work in short steps and save files often. Touch only files under `explainer/`.
