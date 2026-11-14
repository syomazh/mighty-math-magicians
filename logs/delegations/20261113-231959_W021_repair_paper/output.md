The other files (`alt_proof_frobenius.tex`, `alt_proof_accounting.tex`, `GAPS_*.md`) were pre-existing modifications from other work streams — I did not touch them. My changes: `paper/main.tex`, `paper/main.pdf`, `paper/GAPS.md`, `paper/CHANGES_round1.md`, `paper/build/` — exactly the allowed set.

## Summary

**What I did:** Carried out all 14 accepted repairs A1–A14 from `paper/reviews/ADJUDICATION_round1.md` in `paper/main.tex`, exactly as specified:

- **A1:** Restated the normal-form lemma correctly ($T_i'\sim T_{i+r}$) and proved symmetry/transitivity via $\sim$ on smaller subtrees.
- **A2:** Added Lemma `lem:aut-order` with parts (i) (leaf-fixing automorphism is identity) and (ii) (order prime to $p$ implies identity), and rewrote freeness in `prop:free` using the order argument with (iii) $\prod m_j!$ prime to $p$. The rejected "labels distinct ⇒ fixes leaves" step is not used.
- **A3:** Added the map-based definition of isomorphism/automorphism of cyclic trees in `def:skeleton`; proved $\alpha^p=1$ in `prop:carry` via $\sigma^p=1$, distinct labels, and (i).
- **A4/A5/A6:** Termination now derives $W(\mathbf b)=1$ from $W\equiv1\pmod{q-1}$ and $0<W\le q-1$ (no mod-$(p-1)$ congruence); $q=2$ handled by the direct $a_0\mapsto a_0-1$ argument; $W>0$ justified by the label count staying $\ge1$.
- **A7:** Skeleton proposition: stated and proved the base-$p$ digit induction $m_j(U)$, atom maximality, "(2.1) with $q=p$", and well-definedness of contraction on classes.
- **A8:** Digit lemma proved by column addition with carries $c_j$.
- **A9:** Disjointness of the $p$ product sets in the class-size lemma proved via the class-word rotation argument.
- **A10:** "d constant on classes" is now Lemma `lem:d-invariant` with proof.
- **A11/A12/A13:** Depth-invariance base case and (R2) step; "by maximality" in terminal vectors; fixed wreath-product antecedent.
- **A14:** Repaired two `Lemma~`<CR>`ef{...}` corruptions (byte-level) and scanned for other control characters (none).

**Files changed:** `paper/main.tex`, `paper/main.pdf` (recompiled, 12 pages), `paper/GAPS.md`, and new `paper/CHANGES_round1.md` (per-item table) plus `paper/build/` artifacts.

**Could not do / did not verify:** The repaired proofs are checked only against the adjudication text; no independent reviewer has attacked the round-1 draft. I did not re-render/visually inspect the TikZ figures in the new PDF (examples were unchanged). No `\GAP` markers were needed.
