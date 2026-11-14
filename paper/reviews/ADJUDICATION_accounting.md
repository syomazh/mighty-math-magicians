# Adjudication of the review of the second proof (`paper/accounting_proof.tex`)

By Claude Fable 5.2 (orchestrator), 2026-11-14 ~00:50 PT. The review is `accounting_review_claude_fresh.md`, by a fresh Claude instance that read the note and only the parts of `paper/main.tex` it depends on, and ran its own scripts (`scratch_accounting/`, all pass). Not human-verified.

**Its verdict.** The proof of the theorem C·∏m_j! ≡ (−p)^t (mod p^(t+1)) is correct: no mathematical error in the lemmas, the corollary or the final argument; no circularity; the results quoted from the main paper are true as quoted, including the iterated-carries argument applied to m labels of class 0, the case q = 2 and the count of carries. "Minor revision": 1 WRONG (a closing remark false for q = 2) and 7 GAP (2 moderate, 5 minor), each a missing statement, citation or hypothesis.

**Actions (all accepted and applied).**

| Finding | Action |
|---|---|
| The closing remark about p^k − 1 dividing m is false for q = 2. | Restricted to q > 2; the q = 2 case stated. |
| Item (C) was a re-reading of a proof under a new hypothesis, not a statement of the main paper; it needs Σa_c ≥ 1. | Now a lemma of the note ("Iterated carries, general form") with its hypothesis and a full proof. |
| Dependencies understated; the last clause of (A) misattributed. | The list now names every result used: Blocked form, Class size and Plane representatives, Skeleton nodes are asymmetric, the carry proposition, Terminal vectors, the automorphism lemma, and the fixed-point congruence for a Z_p-action (proved in a line). |
| Section 3 did not say m is arbitrary although the induction goes to ⌊m/p⌋. | Stated. |
| Automorphisms counted as leaf permutations without justification. | Sentence added (an automorphism fixing every leaf is the identity). |
| The step for K(a): centralizer of a p-cycle and the use of p prime unstated. | Spelled out. |
| Sand, part (b), needs m ≥ 1. | Added. |
| The corollary (Legendre's formula with its residue) had no proof. | One-line proof added. |
| It should be said plainly that the note uses v_p(m!) and depends on the main paper's carry proposition. | The status box now says exactly that. |

**State.** `paper/accounting_proof.pdf` compiles. One review round, by one reader; the repairs are not re-reviewed. Claims C12 and C13 are graded `ai-reviewed` with that qualification. Human sign-off: none.
