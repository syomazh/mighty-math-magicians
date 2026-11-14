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

---

# Second audit: the prime-power and residue files

Audit by another separate Claude instance (Claude Fable 5.2, fresh context), 2026-11-14, about 14:57 to 15:20 PT. Written up by the orchestrator from the auditor's report, as above. Not human-reviewed.

**Scope.** The state of commit `d180c73`: `LBlocked`, `ReductionB`, `RetypeB`, `CherryB`, `BlockedForm`, `ExactBCond`, `ExactB`, `Residue`, `ResidueB`, the new lines of `Axioms.lean`, and `lean/README.md` as it was then. Files added later (`ResidueForms.lean`, `NormalForm.lean`) were **not** audited; `ResidueForms.lean` consists of the auditor's own lemmas.

## Verdict

"**Yes, with caveats.** I could not break any of the three claims: the Lean statements say what is claimed, they compile from source with only propext / Classical.choice / Quot.sound, and they agree with my own numerics. No finding of severity WRONG or OVERCLAIM. The caveats are scope and wording (tree counts, not the binomial formula; the residue is indexed by leaves and not stated in the paper's form; a few stale lines)."

## What the auditor did

- **Statements.** `PTree (p ^ k)` with `nodes = n` is the type of plane q-ary trees with n internal nodes (anchor proved from the definitions: exactly one quaternary tree has one internal node). No truncated subtraction. The hypothesis m ≡ 1 (mod p^k − 1) loses no generality: it holds exactly for the m that have q-ary trees, and it is needed. In the residue statement the product is formed in ℕ and then cast; it is the product over all digits of m (proved in Lean against `Nat.digits`). The residue statement contains the paper's residue: the auditor derived from it, in Lean, the exact valuation and the form "C = p^t·c with c·∏ m_j! = (−1)^t in `ZMod p`".
- **Shortcuts.** None in the nine files. `Step4B` is discharged by a complete proof. `BlockedForm.lean` proves a real bijection. Dependency scan of the proof terms: `problem137` reaches 12482 constants (541 of the project, none unresolved), `residue_primePower` 13075; axioms exactly the three standard ones. Factorial facts reached: `Nat.factorial`, `Nat.factorial_succ`, `Nat.mul_factorial_pred`, `Nat.Prime.dvd_factorial`, and for the residue `ZMod.wilsons_lemma`. No binomial coefficient, no Legendre, Kummer or Lucas lemma.
- **Independent run.** All 30 imported modules and `Axioms.lean` compiled from source, one at a time, outside the repository's build directory: every file exits 0 with no warning. A false instance (v_2 = 2 for q = 4, n = 3) is not derivable.
- **Truth of the statements.** Own Python recursions (by nodes, by leaves, and for blocked p-ary trees) for q in {2, 3, 4, 5, 7, 8, 9, 16, 25, 27} and all n from 0 to 110: 1110 pairs, no mismatch in the closed formula, in (p − 1)v_p + 1 = s_p((q − 1)n + 1), in count·∏ m_j! ≡ (−p)^t (mod p^(t+1)), or in the paper's form of the residue.
- **Instances derived in Lean and compared with Python** (all agree): 25 instances of `problem137` for q in {4, 8, 9, 16, 25, 27}; 5 of `exact_valuation_primePower`; 6 of the residue, each with some digit ≥ 2 (for example q = 25, m = 49, digits 4, 4, 1: count·576 ≡ 25 mod 125, with count = 25).

## Findings and what was done

| # | Severity (auditor) | Finding | What was done |
|---|---|---|---|
| 1 | GAP, disclosed | For q > 2 the theorems are about the number of q-ary trees, not about binom(qn, n)/((q − 1)n + 1). | Unchanged; said in the README. A worker (W024) is attempting the closed formula. |
| 2 | GAP, small | The residue was stated only by leaves and as an integer congruence; no form by nodes, none in the paper's form. The auditor proved four lemmas that give these. | Adopted as `lean/MMM/ResidueForms.lean`: `residue_paper_form`, `residue_nodes`, `prod_dig_eq_digits`, `exact_of_residue`. |
| 3 | COSMETIC | `problem137` read alone relies on `multiplicity p 0 = 0`. | The auditor's convention-free form by nodes adopted as `problem137_exact` (positive, divides, does not divide). |
| 4 | COSMETIC | README: "six instances" (seven); the trust section did not cover the residue statement; the residue sentence omitted m ≡ 1 (mod q − 1); `blockedAt_realize` not printed in `Axioms.lean`. | All corrected. |
| 5 | COSMETIC | Stale header comments that under-claimed (`Exact.lean`, `CherryB.lean`, `Blocked.lean`, `Axioms.lean`). | Corrected (comments only). |
| 6 | COSMETIC | `card_pow_ary_eq_card_blocked` takes an unused hypothesis 2 ≤ p. | Left as it is; harmless. |
| 7 | Caveat on the trust base | As in the first audit: Mathlib from the prebuilt cache, a release-candidate toolchain, no `lean4checker` replay, and an AI reading, not a human one. The residue uses Wilson's theorem. | Stated in the README. |
