# W005 — Interactive explainer (HTML)

Audience: a first-year undergraduate and the hackathon judges. Purpose: let someone *see* why v_p(C_n^(q)) = (s_p(m) − 1)/(p − 1): trees, rotation classes, digits as atoms, carries as collapsing cherries.

Read `notes/2026-11-13_candidate_proof_sketch.md` and `CLAIMS.md`. Nothing here is verified by the team yet: put a small footer line "Candidate argument, not yet verified by the team" and do not call anything a theorem.

Write `explainer/index.html`: one self-contained file, vanilla JavaScript and inline SVG, no external libraries, no network requests, opens by double-click. Light and dark via `prefers-color-scheme`. Readable at 1280 px and at phone width. First line an HTML comment naming your model.

Sections:

1. **Controls.** p in {2, 3, 5}, k in {1, 2}, n by slider. Show q, C_n^(q), and m = (q−1)n+1 written in base p as coloured "atom" chips (one chip per unit of each digit, labelled p^j), then s_p(m) and t. Count classes through canonical forms and memoized recursion so that n can go reasonably high; cap n where it gets slow.
2. **Orbit census.** Bar chart: number of classes N_d by size p^d, the bar d = t highlighted. Show the identity C_n^(q) = Σ_d N_d·p^d with the actual numbers, and N_t mod p.
3. **A tree and its symmetries.** Draw a q-ary tree as a p-ary tree (the depth-k blocks faintly shaded); colour symmetric and asymmetric nodes differently; show the class size p^d. Clicking a node rotates its p children with a short animation. Buttons: random tree, jump to a minimal tree.
4. **Minimal trees are built from the digits of m.** Gallery of the minimal classes (at most 30) drawn as skeleton trees whose leaves are atom chips. For p = 2 note that these are the rooted binary trees on the 1-bits of m, the same objects biologists use for evolutionary trees.
5. **A carry is a collapsing cherry.** Step-through animation on a labelled skeleton tree: choose p labels of one class, show Z_p cycling them, show that a tree is fixed exactly when they are siblings (a "cherry"), collapse the cherry into one atom of the next size; next to it show the base-p column addition performing the same carry. A running sign (−1 per step) until one leaf remains.

Keep the pure counting logic in `explainer/logic.js` and inline an identical copy into `index.html` between the marker comments `/* LOGIC-BEGIN */` and `/* LOGIC-END */`. Write `explainer/selftest.mjs` (run `node explainer/selftest.mjs`) that checks the two copies are identical and that the logic reproduces, for every row of `experiments/E000_first_sanity_check/output.txt`, the values C_n, min d, #orbits and N_min. Run it and fix failures.

Touch only files under `explainer/`.
