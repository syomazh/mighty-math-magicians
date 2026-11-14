# Findings, ranked

_Maintained by the orchestrator (Claude Fable 5.2). Last updated 2026-11-13 23:55 PT._
_Purpose: one short page telling the humans what matters most. Details live in the linked files. Nothing here is human-signed unless it says so._

**If you read one thing:** the briefing PDF, `notes/briefing_grad_student/briefing_for_grad_student.pdf`. **To check the proof line by line:** `paper/main.pdf` (12 pages). **To learn it:** `notes/study_guide.md`.

## Tier 1 — the talk is built on these

| # | Finding | One-sentence version | Status | Where |
|---|---|---|---|---|
| 1 | **The main proof** | Rotate the children of each node (a p-group) instead of permuting them; every class has p^d trees; the smallest classes are trees built on the base-p digits of m; a carry is a cherry collapsing, so their number is not divisible by p. | Brute force passes. **Stress test passes on 1067 values of m** (up to 400 leaves, p ≤ 13, k ≤ 4). Three AI reviewers: no counterexample, 14 write-up defects, all repaired; I then found and fixed 4 more. An independent Claude referee is reading the repaired paper. **Not human-signed.** | `paper/main.pdf`; `paper/reviews/` |
| 2 | **"Every node is worth −p"** | Label the leaves: a tree has (m−1)/(p−1) nodes, each worth a factor −p; the m! labellings can absorb only the nodes of the "digit forest"; the t nodes left over are the valuation. In one line: C_n^(q)·∏ m_j! ≡ (−p)^t (mod p^(t+1)). | The congruence holds in 885 cases. The proof is a sketch; a worker's check of each lemma is still running. It passes through v_p(m!), derived by symmetry; whether that meets the brief is the humans' call. | `notes/2026-11-13_new_ideas.md`, Idea 1 |
| 3 | **The classes are known objects in chemistry and biology** | For p = 3 the rotation classes are exactly the stereoisomers of alkyl radicals C_nH_{2n+1} (a carbon's three other bonds can be rotated, not reflected). For p = 2 they are the shapes of evolutionary trees. | Sequence match checked in the OEIS (A000625, A001190). Deeper leads unverified. | `notes/2026-11-13_new_ideas.md`, Idea 3 |
| 4 | **Sand on a ring versus sand on a line** | With the rule "p grains topple into one grain on the next site", v_p(C_n^(q)) = (topplings of m grains on a ring of k sites) − (topplings on a line). | The arithmetic identity is immediate; the interpretation is being checked. | `notes/2026-11-13_new_ideas.md`, Idea 2 |

## Tier 2 — one slide or one remark each

| # | Finding | Status | Where |
|---|---|---|---|
| 5 | **Where we stand against prior work.** For p = 2 the orbit argument with exactness is Deutsch–Sagan (and Postnikov–Sagan, weighted); Konvalinka uses the full symmetric group and gets divisibility only; Gao–Gu and Krattenthaler–Müller are algebraic. Not found in those texts: the p-group action for q = p^k, the digit skeleton with its depth condition, the carry–cherry count. | A worker read four full texts; this is **not** a novelty certificate. The professor's view is needed. | `references/overlap_fulltext.md` |
| 6 | **The Frobenius view: a second, algebraic proof for q = p.** The generating function satisfies G = x + G^p; modulo p, G^p = G(x^p), so G ≡ x + x^p + x^(p²) + …, which gives "C is prime to p exactly when m is a power of p" in one line. Keeping track of G^p − G(x^p) reproduces the rotation classes. | 2584 numerical checks pass (E005). A written note exists with one marked gap. A model searching blind, without seeing our work, found this route too and ranked it the most elegant. Not reviewed. | `paper/alt_proof_frobenius.tex`, `experiments/E005_frobenius_proof/` |
| 7 | **Refinement by level profile** (the problem statement asks for "other statistics"): for every way of fixing the number of nodes at each depth, the number of trees is still divisible by p^t. Arithmetically: p^t divides ∏ binom(q·n_i, n_(i+1)). | Holds for every profile tested (n up to 22 for q = 2, up to 12–15 for q = 3, 4, 5, 8, 9). Follows from findings 1 once signed. | `experiments/E002_extensions/` |
| 8 | **The weighted theorem with the smaller group** (Konvalinka's Theorem 5 without factorials). | Numerically supported for 6 values of q and 4 weight functions each, no failures; a control with a non-transitive group fails, as predicted. Not written up. | `experiments/E002_extensions/` |

## Tier 3 — parked

- Other closed families (bounded height, all leaves deep): divisibility holds in all tested cases.
- A bijection between labelled cyclic p-ary trees and permutations made of p-cycles: not tested.
- q not a prime power: not explored (worker stopped).
- Residues modulo p²: data only.
- An observation from the data: for binary trees the number of level profiles with valuation exactly t is 1, 3, 13 for t = 1, 2, 3. These look like the ordered Bell numbers. Unexplained.

## Suggested shape of the 20 minutes

Finding 3 as the hook (2 min) → the statement and what was missing (3 min) → Finding 1, the proof (9 min) → Finding 2 or 6, a second way to see it (3 min) → Finding 5, honest position (1 min) → Findings 7–8 if signed (1 min) → how AI was used and checked (1 min).

## Verification at a glance

| Layer | State |
|---|---|
| Brute force by the author of the idea (E000) | passes |
| Independent code by another model (E001) | agrees for k = 1, small n only |
| Large-scale stress test, no assumptions (E003) | passes: 1067 values of m, p ≤ 13, k ≤ 4 |
| Three adversarial AI reviews, round 1 | no counterexample; 14 write-up repairs |
| Orchestrator's line-by-line check after repair | 4 further defects found and fixed |
| Independent Claude referee, round 2 | running |
| Human sign-off | **none yet** |
