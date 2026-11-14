# Independent audit of the Lean statements

Audit by a separate Claude instance (Claude Fable 5.2, fresh context, no access to the orchestrator's session), 2026-11-14, about 14:10 to 14:30 PT. This file was written by the orchestrator (Claude Fable 5.2) from the auditor's report: the verdict, the findings and the tables are the auditor's; the column "what was done" is the orchestrator's. Not human-reviewed.

**Scope.** The state of commit `db256de`: the 22 Lean files of the case q = p and `lean/README.md` as it was then. The prime-power files added afterwards (`LBlocked`, `ReductionB`, `RetypeB`, `CherryB`, `BlockedForm`, `ExactBCond`, `ExactB`) were **not** audited.

**The auditor's brief** was to try to break the claim "Lean has verified the exact valuation for q = p": check that the statements say what is claimed, look for shortcuts, run Lean independently, test the statements numerically, and look for overclaims in the README.

## Verdict

"**Yes, with caveats.** Lean has verified, for every prime p, the exact power of p in the number of p-ary plane trees with m leaves, and v_2(C_n) = s_2(n+1) − 1 for Mathlib's Catalan numbers. I could not break it. The caveats are about wording and scope, not truth: the Lean object for p ≥ 3 is a tree count indexed by leaves, not the binomial Fuss–Catalan number indexed by n."

No finding of severity WRONG.

## What the auditor did

- **Statements.** Read `PTree`, `leaves`, `ds` and the Mathlib definitions of `multiplicity`, `Nat.digits`, `catalan`, `Nat.card`. Restated the three final theorems with root names and no namespace open; the project's theorems prove them as written. Checked that nothing is shadowed, that no subtraction is truncated, that the hypothesis of `exact_valuation` is solvable exactly when trees exist, and that `exact_valuation` itself forces the number of trees to be non-zero.
- **Shortcuts.** No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`, `implemented_by`, `opaque`, `extern`, `set_option`, macros or `#eval` in the 22 files. A scan of the proof term of `exact_valuation` reaches 11957 constants, 411 of them in the project, none unresolved; the only axioms are `propext`, `Classical.choice`, `Quot.sound`. The only factorial facts reached are `Nat.factorial`, `Nat.factorial_succ`, `Nat.mul_factorial_pred`, `Nat.Prime.dvd_factorial`: no binomial coefficient and no Legendre, Kummer or Lucas lemma, also not in the Catalan statement.
- **Independent run.** Compiled all 22 files from source, one at a time, into a scratch directory with the repository's build products removed from the path: every file exits 0 with no warning. A deliberately false instance (v_3 = 2 for 7 leaves) fails, as it should.
- **Truth of the statements.** Its own Python recursion for p in {2, 3, 5, 7} and all m ≤ 130: 250 pairs (p, m), no mismatch with (s_p(m) − 1)/(p − 1), with the closed formula binom(pn, n)/((p − 1)n + 1), or with the Catalan numbers; v_2(C_n) = s_2(n + 1) − 1 for n < 400.
- **Instances proved in Lean from the theorems and compared with Python** (all agree): ternary trees with 3, 5, 7, 9, 11, 25, 27, 79 leaves; 5-ary with 9, 13, 25, 121, 125; 7-ary with 13, 49, 97; binary with 7, 8, 23; Catalan numbers C_n for n in {0, 1, 2, 3, 4, 5, 6, 7, 10, 22, 62, 63, 100}. Also, directly from the definitions: there is exactly one ternary tree with 3 leaves, and the number of binary trees with 7 leaves is `catalan 6 = 132`.

## Findings and what was done

| # | Severity (auditor) | Finding | What was done |
|---|---|---|---|
| 1 | GAP, small | The README and a docstring say "n internal nodes", but the theorem counts trees with (p − 1)n + 1 leaves; no theorem related `nodes` to `leaves`. The auditor supplied two lemmas that close this. | Added, in `ExactB.lean`: `PTree.leaves_eq_nodes`, `PTree.card_nodes_eq_card_leaves`, `PTree.fussCatalan_valuation_nodes`, and the prime-power theorem `PTree.problem137` is stated by internal nodes. |
| 2 | GAP, disclosed | For p ≥ 3 the theorem is about the number of trees, not about binom(pn, n)/((p − 1)n + 1); the name `fussCatalan_valuation` suggests more. | Still true. The README says so in three places. An Open Math OS worker (W024) is attempting the closed formula in Lean. |
| 3 | COSMETIC | `multiplicity p 0 = 0` by convention, and `Nat.card` of an infinite type is 0; the "what one has to trust" section did not mention either. | README now says that the "divides / does not divide" form is the convention-free one. |
| 4 | COSMETIC | `Axioms.lean` did not print five entries of the README table. | The five lines were added. |
| 5 | GAP in documentation, minor | "Not checked by Lean" was not exhaustive: the corollary "Exact count when k = 1", the worked examples, and the fact that Lean never forms cyclic trees or automorphisms (the paper's skeleton definition and the lemmas around it). | README: one more row and one more difference. |
| 6 | COSMETIC | The values 132 and 429 were only in comments. | Wording of the README changed. |
| 7 | Caveat on the trust base | Mathlib's compiled files come from the prebuilt cache and were not re-checked; the Lean toolchain is a release candidate; no external kernel replay (`lean4checker`) was run. | Stated in the README. Not addressed otherwise. |

## What this audit does not cover

- It is an AI reading. No human has read the Lean files.
- The prime-power files, and everything written after 14:30.
- Whether the Lean proof is the paper's proof step by step: the auditor compared structure and the listed differences, it did not referee the paper.
