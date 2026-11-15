# Adjudication of the review of the carry-budget note (`notes/2026-11-14_carry_budget.md`)

By Claude Fable 5.2 (orchestrator), 2026-11-14 about 10:15 PT. The review is `carry_budget_review_claude_fresh.md`, by a fresh-context Claude instance that read only the note and was given the bare definitions. Its own code is in `scratch_carry_budget/`. Not human-verified.

**Its verdict.** The mathematics is correct: Facts 1–3, the lower bound and the two-condition criterion for minimal trees (with its induction) are proved as written, and neither a hand check nor its code could break them. Tests: 1,364,923 rotation classes exhaustively (p = 2 up to 20 leaves, p = 3 up to 29, p = 5 up to 49, p = 7 up to 61); about 60,000 individual trees with rotation equivalence coded literally from the definition; random trees up to 4.8 million leaves for p ≤ 13; the symmetry group built explicitly on 7,004 classes. No violation. Findings: 1 WRONG (minor, an analogy), 3 GAP, 3 UNCLEAR.

**Actions. Every finding was accepted and applied.**

| # | Finding | Action |
|---|---|---|
| 1 (GAP) | The skeleton description was stated in one direction only, "built from the digits of m" was not derived, and existence of a minimal tree was not shown. | The note now has a precise Claim (minimal ⟺ a tree with s_p(m) leaves whose leaves are replaced by a_j complete trees of height j) with a proof in both directions, following the referee's argument, including existence. |
| 2 (UNCLEAR) | "Number of carries" is ambiguous for p ≥ 3: c(v) is the total amount carried, not the number of columns that carry. Under the other reading Facts 1 and 2 fail (three copies of the 5-leaf ternary tree). | A paragraph "What a carry is" defines a carry as one trade of p units for 1 unit in the next column, with the base-3 example. The spoken version, the slide and Q&A 16a say it once. |
| 3 (GAP) | The remark on the symmetry group and Sylow subgroups was asserted without definition or proof. | Definition and the three short proofs added (order p^σ, faithfulness, Sylow ⟺ minimal), with Legendre's formula attributed to a reference in our list. Still marked as not needed. |
| 4 (UNCLEAR) | Spoken version: "what is left over, t nodes" reads as "exactly t". | Now "at least t nodes are left over". |
| 5 (WRONG, minor) | "t is the potential still stored in the digits of m" is off by 1/(p−1). | Replaced by the correct statement: t is the potential gained between one leaf and m leaves, t = (s_p(m) − s_p(1))/(p−1). The same sentence was corrected in `notes/2026-11-14_crossfield_analogies.md`. |
| 6 (GAP, trivial) | Fact 2 uses that equivalent trees have the same number of leaves. | Stated in the Setting. |
| 7 (UNCLEAR) | The status line's test range barely exercises odd primes. | The status line now gives the limits per prime and cites the referee's much larger tests. |
| Observation | Primality is not used in Facts 1–3 or in the first two consequences. | Added as a short section "Where primality is used". |

**State.** Claim C19 is graded `ai-reviewed` with the usual qualification: one round, one reader, the same model as the author; the repairs (in particular the new Claim, which is the referee's own argument written out) are not re-reviewed. Human sign-off: none.
