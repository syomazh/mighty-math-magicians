# Adjudication of the round-3 review

By Claude Fable 5.2 (orchestrator), 2026-11-14 ~00:30 PT. The review is `round3_claude_fresh.md`, by a third Claude instance that read only `paper/main.tex` (the text after the round-2 repairs) and ran its own scripts (`scratch_round3/`). Not human-verified.

## Its verdict

"The main theorem is proved — yes, modulo listed gaps. No lemma, proposition, theorem or corollary is false." Two WRONG findings, both single sentences that affect no proof; six GAP findings, three of them on the proof chain, each closed by one to three lines which the report supplies; eleven consistency notes. Its computations: 58 full tree enumerations and 109 class-level cases with k up to 4 confirm class size p^d, min d = t, the number of minimal classes = the number of cyclic skeleton classes, and the congruence; 221 carry instances give |Fix| = (p−1)·T(a') exactly; all numbers in the examples recompute.

## Findings and actions (all accepted; applied to `paper/main.tex` by the orchestrator)

| Finding | Action |
|---|---|
| G1. Expansion well defined on classes was only asserted. | Expansion E defined recursively; well-definedness proved by minimality of the labelled relation. |
| G2. Contraction applied to an expansion before the expansion was known to be minimal; "expansion reverses contraction" unargued; letters reused. | Converse direction rewritten: minimality of E(S) first, then κ(E(S)) = S and E(κ(T)) = T by induction, as equalities of plane trees; new letter u for the number of skeleton nodes. |
| G3. "The same proofs" for labelled trees is not literally true: R must hold between leaves only when labels agree. | Lemma "Plane representatives" now states that convention, that asymmetry and d are taken through labelled classes, and that equivalent labelled trees have the same multiset of labels. |
| G4. "Set of nodes" excluded leaves by the paper's own definition. | "Vertices" introduced (leaves and internal nodes); isomorphisms are bijections of vertices. |
| G5. Freeness proposition cited the skeleton proposition for the wrong thing and asserted the orbit characterisation. | Rewritten: the forgetful map, the count N_min of its image by the skeleton proposition, and a proof that its fibres are the H-orbits. |
| G6. The final bijection in the carry proposition was stated on classes without the check. | Sentence added: isomorphisms preserve labels, so the collapsed class and the slope are invariants, and reconstruction inverts collapsing. |
| W1. "Replacing an internal node by a root with q new leaves" should be "replacing a leaf". | Corrected, and the leaf-count identity is now stated for arbitrary arity r. |
| W2. "C_8 = 43263" should carry the superscript (3). | Corrected. |
| N2. An unused sentence in the lemma on skeleton nodes, an unused sentence in Section 5.1, a duplicate in the corollary. | Removed. |
| N3. The carries proposition still justified m ≡ 1 by m = (q−1)n+1 rather than by its hypothesis. | Corrected; invariance of W cited. |
| N4. Two phrases about "other leaves" that do not exist. | Removed. |
| N5. Introduction: the fixed-point count is modulo p; the minimum t is attained. | "modulo p" inserted with a pointer to the exact count for k = 1; a remark after the main theorem records that the minimum of d is exactly t. |
| N11. "the full symmetric symmetry group". | Corrected. |

Left for the final edit (cosmetic): N1 (position of a display), N6 (the unused remark on Sylow subgroups; "orbits" versus "classes" in the abstract), N7 (overloaded letters), N8 (unused macros and labels), N9, N10, the author line, volume data for one reference.

## State

`paper/main.pdf` compiles (13 pages, no undefined references). Three review rounds, by three AI models from two other vendors and by three independent Claude readers (the orchestrator's own line-by-line read and two fresh instances), produced 14 + 4 + 10 + 13 repairs and no counterexample. The repairs of round 3 have not themselves been re-reviewed by a machine. **The next and decisive check is the human one.**

What the pattern of findings says: each round found fewer and smaller defects on the proof chain (two false steps; then a false displayed equality and a missing hypothesis; then three steps asserted without proof), and the latest defects sit in the text written during the previous repair. A human reader should therefore look hardest at the most recently written passages: the lemma "Plane representatives", the converse half of the proposition "Minimal classes are skeleton trees", and the freeness proposition.
