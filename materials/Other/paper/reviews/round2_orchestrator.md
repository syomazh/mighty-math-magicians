# Round 2, part 1: the orchestrator's own check of the repaired paper

By Claude Fable 5.2, 2026-11-13 ~23:40 PT. I read `paper/main.tex` (as revised by worker W021) from the Introduction through the proof of the main theorem and the exact-count corollary, line by line, against `ADJUDICATION_round1.md`. I did not re-read the worked examples (all three round-1 reviewers recomputed them). Not human-verified. I am the author of the proof idea, so this is not an independent review; part 2 is a fresh-context review.

## Repairs A1–A14

| # | Verdict | Note |
|---|---|---|
| A1 normal form | fixed, with one further correction by me (R1 below) | statement is now "T'_i ~ T_{i+r} for all i" |
| A2 freeness | **fixed** | new Lemma `lem:aut-order` (i), (ii); the proof now equates the orders of φ and h and uses that \|H\| is prime to p |
| A3 α^p = 1, map-based definitions | fixed | isomorphisms of cyclic trees are now defined as maps |
| A4 termination, W = 1 | **fixed** | from W ≡ 1 (mod q−1), 0 < W ≤ q−1, q−1 > 1 |
| A5 q = 2 | fixed | direct count of carries |
| A6 W > 0 | fixed | |
| A7 atoms = digits | fixed, with one further correction by me (R2 below) | induction on minimal trees is now explicit |
| A8 digit lemma | fixed | column addition, identity Σ s_p(a_i) − s_p(Σ a_i) = (p−1) Σ c_j |
| A9 disjointness in class size | fixed | |
| A10 d constant on classes | fixed | now a lemma |
| A11 depth invariance | fixed | |
| A12 terminal vectors | fixed | |
| A13 wreath remark | fixed | |
| A14 broken `\ref` | fixed | compiles with no undefined references |

## Further defects I found and corrected in `paper/main.tex` (none was raised in round 1)

- **R1. Normal-form lemma, proof order.** The proof used "R satisfies (R2)" before establishing that R implies ~, which that step needs. Reordered: first R ⇒ ~ (no minimality), then R satisfies (R2) and (R1), then minimality. Also made explicit that a leaf is equivalent only to a leaf.
- **R2. Skeleton proposition, converse direction.** The text said "(S1) says exactly that all surviving internal nodes are asymmetric", which is not a proof. Replaced by the digit argument: if the p expanded child subtrees at a skeleton node were equivalent they would have equal leaf counts, hence equal digit vectors, so every atom count below the node would be a multiple of p and less than p, hence zero. Added that the maximal complete subtrees of the expansion are therefore exactly the atoms, which is what "expansion reverses contraction" needs.
- **R3. False equality in the invariant.** The display read Σ_c a_c p^c = Σ_j m_j p^j. These are equal only modulo q − 1 (the left side is Σ_j m_j p^(j mod k)). Corrected to a congruence with its reason, p^k ≡ 1 (mod q−1). The rest of the argument only ever used the congruence.
- **R4. Carry proposition, the count p − 1.** The affine form of the label positions was assumed before being derived. Now derived from f(u + r) = f(u) + 1.

## Verdict

With R1–R4 applied I find no remaining gap in Sections 2–6 (definitions through the main theorem). The exact-count corollary uses the Fuss–Catalan counting formula, as it says, and is not used in the main theorem. The paper compiles (12 pages, no undefined references): `paper/main.pdf`.

That three reviewers missed R3, a plainly false displayed equality, is a reminder that AI review does not replace the human check.
