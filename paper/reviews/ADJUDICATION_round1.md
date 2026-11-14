# Adjudication of the round-1 reviews of `paper/main.tex`

By Claude Fable 5.2 (orchestrator), 2026-11-13 ~23:35 PT, after reading the detailed findings of `review_kimi.md`, `review_mistral.md`, `review_muse.md`. Not human-verified.

**Overall.** All three reviewers: the main theorem is proved "modulo listed gaps"; no counterexample; no hidden use of Legendre, Kummer or factorial valuations; all worked examples recompute correctly. The defects below are in the write-up, not in the strategy. Two of them are steps that are false as written.

## Accepted findings (must be repaired)

| # | Where | Defect | Required repair | Source |
|---|---|---|---|---|
| A1 | Normal-form lemma | The displayed equivalence is false as written (it says T' is a rotation of its own subtree tuple). | State: T ~ T' iff there is r in Z_p with T'_i ~ T_{i+r} for all i (indices mod p). Prove symmetry and transitivity using symmetry/transitivity of ~ on smaller trees. | Mistral F1, Muse F5 |
| A2 | Freeness of the action of ∏ S_{m_j} | **False step.** "The automorphism sends each leaf to a leaf with the same label, hence fixes every leaf." If h·τ = τ, the witnessing automorphism φ sends the leaf labelled x to the leaf labelled h(x), not to itself. | Use the order argument. (i) An automorphism of a cyclic p-ary tree that fixes every leaf is the identity, so φ is determined by h and has the same order as h. (ii) An automorphism of a cyclic p-ary tree whose order is prime to p is the identity: at the root it induces a rotation in Z_p of order dividing both p and its own order, hence trivial; so it preserves each child subtree; induct. (iii) \|∏ S_{m_j}\| = ∏ m_j! is prime to p since m_j < p, so if h ≠ 1 fixed τ, a suitable power of h of prime order ℓ ≠ p would fix τ, contradicting (ii). | Mistral F2. **Note:** Kimi F4 and Muse F1 propose "fixes each leaf because labels are distinct" as the repair; that is the same false step and is rejected. |
| A3 | Carry proposition | α^p = 1 asserted without proof; "cyclic tree", "isomorphism", "automorphism" never defined as maps. | Define an isomorphism of (labelled) cyclic trees as a root-preserving bijection of nodes preserving parent–child and the cyclic order of children at every node (and labels, classes). Then α^p fixes every leaf (labels distinct, σ^p = 1), hence is the identity by A2(i). | Mistral F3, Kimi F5 |
| A4 | Termination, "W = q − 1 is impossible" | **False for p = 2.** The paper derives a contradiction from Σ b_c ≡ 0 versus ≡ 1 (mod p − 1); modulo 1 this is no contradiction. | Use the invariant itself: W(b) ≡ 1 (mod q − 1) and 0 < W(b) ≤ q − 1 with q − 1 > 1 force W(b) = 1, hence b = e_0. No digit-total congruence. | Kimi F1. **Note:** Mistral F4 and Muse F9 call the original argument correct; they are wrong for p = 2 (for example p = 2, k = 2, b = (1,1)). |
| A5 | Termination, q = 2 | The stated reason ("≡ 1 mod p − 1") is vacuous. | For q = 2 a carry sends a_0 to a_0 − 1 and is possible exactly while a_0 ≥ 2; starting from a_0 = s_2(m) ≥ 1 the process ends at a_0 = 1 after s_2(m) − 1 carries. | Kimi F2, Mistral F4, Muse F10 |
| A6 | Termination, W > 0 | Asserted without reason. | The number of labels starts at s_p(m) ≥ 1, is ≡ 1 (mod p − 1) … for p = 2 argue directly: a carry needs at least p labels and leaves at least one, so the number of labels is always ≥ 1; hence W(b) ≥ 1. | Muse F8 |
| A7 | Skeleton proposition | The induction showing "atoms = base-p digits of m" is not stated; "union of multiplicities" is imprecise; maximality of atoms not argued; equation (2.1) used with q = p without saying so. | For a minimal tree U let m_j(U) be the number of atoms of height j. Prove by induction: ℓ(U) = Σ_j m_j(U) p^j with 0 ≤ m_j(U) < p, i.e. the m_j(U) are the base-p digits of ℓ(U): atom base case; at an asymmetric root the carry-free property makes digit vectors add componentwise. Say why a complete subtree hanging from an asymmetric node is a maximal complete subtree. Say "(2.1) with q = p". Also state that contraction is well defined on classes. | Kimi F3, Mistral F5, Muse F3, F4 |
| A8 | Digit lemma | Termination/canonicity of "merge equal powers" left implicit. | Prove by column addition: if c_j is the carry out of column j when adding a_1, …, a_r in base p, then s_p(Σ a_i) = Σ s_p(a_i) − (p − 1) Σ_j c_j. Equality iff all c_j = 0. | Kimi F6 |
| A9 | Class-size lemma | Disjointness of the p product sets asserted. | If rot_r(U) = rot_s(V) with U_i, V_i in the class B_i then B_{i+r} = B_{i+s} for all i, so the class word is fixed by a non-trivial rotation, hence constant (p prime). | Mistral F5 |
| A10 | Before the class-size lemma | "d is constant on classes" is argued in prose only. | Make it a lemma with proof (from the corrected normal form). | Mistral F5 |
| A11 | Depth-invariance lemma | Leaf base case and the (R2) step omitted. | Add both, one sentence each. | Muse F6 |
| A12 | Lemma "T(a) = 0 when all a_c < p" | "by maximality" missing. | A deepest internal node has only leaves as children, all at the same depth, hence of the same class. | Muse F2 |
| A13 | Remark on the wreath product | "they induce a Sylow p-subgroup" has the wrong antecedent. | Say: the permutation group induced on the q bottom slots of one block by the rotations at the nodes of that block is Z_p ≀ … ≀ Z_p (k factors), a Sylow p-subgroup of S_q. | Kimi F7 |
| A14 | Source typos | `Lemma~ef{...}` (a broken `\ref`) occurs twice. | Fix; grep the source for control characters. | Muse F11 |

## Rejected or no action

- Kimi F4 / Muse F1 proposed repair of freeness: rejected, see A2.
- Mistral F4 / Muse F9 "the W = q − 1 argument is correct": rejected, see A4.
- Muse F7, F12: no defect claimed.

## Consequence for the claim ledger

The proof strategy survived three independent attacks; the write-up needs the repairs above. C1–C8 stay at `computed` until the repaired paper passes a second review round, then move to `ai-reviewed`. The briefing sent to the grad student already uses the correct arguments for A2 (order argument) and A4 (invariant argument).
