# Adjudication of the independent round-2 review

By Claude Fable 5.2 (orchestrator), 2026-11-14 ~00:05 PT. The review is `round2_claude_fresh.md`, written by a second Claude instance that was told not to read any of our notes, earlier reviews or the claim ledger; it read only `paper/main.tex` and ran its own scripts (`scratch_fresh/`). Not human-verified.

## Its verdict

"Is the main theorem fully proved? Yes, modulo the listed gaps." Over the 27 numbered environments: 1 WRONG (an explanatory sentence in a worked example), 6 GAP, 20 CORRECT. It found no step whose conclusion is false and none that needs a new idea. Every attack it was asked to make on the core argument held up by hand (normal form, class size, digit lemma, both cases of the lower bound, the automorphism lemma and freeness, the carry proposition including the wrap-around, termination for q = 2, q = 3 and (p,k) = (2,2)), and all its computations passed, including exact fixed-point counts |Fix| = (p−1)·T(a') and every order of carries for n up to 399. No hidden use of Legendre or Kummer; the exact-count corollary is not circular.

## Findings and what was done (all accepted; all applied to `paper/main.tex` by the orchestrator)

| Finding | Severity | Action |
|---|---|---|
| F1. Example 7.2: the sentence describing the two pictured skeletons is false (both cherries have a repeated height; the factor 2 comes from the root). Also the last line credits the wrong proposition. | WRONG (example text only; all numbers right) | Replaced by the correct breakdown 1 + 1 + 2 + 2 + 4 = 10; reference changed to the main theorem. |
| F2. Skeleton section: bijection stated for trees rather than equivalence classes; the identification of cyclic-tree isomorphism with rotation equivalence of plane labelled trees was asserted inside a definition; "(S1)–(S2) hold" with only (S2) argued; (S1) is in fact redundant; contraction not defined; missing qualifiers in the statement. | GAP | Statement now speaks of equivalence classes and has the qualifiers. New Lemma "Plane representatives" proves the identification. Axiom (S1) removed; new Lemma "Skeleton nodes are asymmetric" proves it. Contraction κ defined recursively and shown well defined on classes by induction. The remaining condition is now called (S). |
| F3. The "iterated carries" proposition is false as literally stated without the hypothesis m ≡ 1 (mod q−1); counterexample (p,k,m) = (2,2,2). | GAP (missing hypothesis) | Hypothesis added to the statement. |
| F4. Depth-invariance lemma argued by "induction on generating steps", which is not defined. Same phrase at the start of the proof that d is constant on classes. | GAP | Both proofs rewritten: the first by minimality of ~ (the relation "same multiset of leaf depths" satisfies R1 and R2), the second by induction on size through the normal form. |
| F5. Existence of the smallest equivalence relation not justified. | GAP (trivial) | One sentence added. |
| F6. Exact-count corollary: the factor p^t needs the labelled version of the class-size lemma. | GAP (minor) | Now derived from the two new lemmas. |
| F7. Introduction: the identity "number of trees = binomial expression" has no reference. | GAP | Reference to Konvalinka (who recalls it as well known) added, with a sentence on where the identity is and is not used. |
| F8. "No valuation of a factorial is used below" is too strong as worded. | wording | Restricted to the proof of the main theorem, with the exception "a! is prime to p for a < p" stated. |
| F9. Deutsch–Sagan and Postnikov–Sagan in the bibliography but never cited; prior work for p = 2 not discussed. | scholarship | New paragraph in the Introduction on the case p = q = 2, citing both and Kersting–Fischer (2021), and saying what the present argument adds. Bibliography entry added (data verified through OpenAlex and Semantic Scholar; see `references/README.md`). |
| F10. Minor: missing citation of the d-invariance lemma in the lower bound; "beyond the top column"; a slip of wording in the moving-leaf lemma; tidying of the last paragraph of the main proof and of the theorem statement; notation in the examples preamble; misplaced depth labels in a figure. | minor | Items 1, 2, 3, 4, 7, 8 fixed. Items 5 and 6 (the word "node"; overloaded letters) left for the final edit. |

## Not done

- Overloaded symbols and the double use of "node" (F10.5, F10.6): cosmetic, left for the final edit.
- The referee did not check the three references; nor could it. The description of Konvalinka's method in the Introduction was written from our own full reading of his paper (journal entry 2026-11-13 21:00); the statements about Deutsch–Sagan rest on a worker's full-text read (`references/overlap_fulltext.md`) and should be confirmed by a human.

## State of the paper

`paper/main.pdf` compiles (13 pages, no undefined references). Two review rounds by four reviewers have produced 14 + 4 + 10 repairs and no counterexample. A third pass by a fresh reviewer on the final text is the remaining machine check; the decisive check is the human one.
