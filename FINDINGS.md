# Findings, ranked

_Maintained by the orchestrator (Claude Fable 5.2). Last updated 2026-11-13 23:30 PT._
_Purpose: one short page telling the humans what matters most. Details live in the linked files. Nothing here is human-signed unless it says so._

**If you read one thing:** the briefing PDF, `notes/briefing_grad_student/briefing_for_grad_student.pdf`.

## Tier 1 — the talk is built on these

| # | Finding | One-sentence version | Status | Where |
|---|---|---|---|---|
| 1 | **The main proof** | Rotate the children of each node (a p-group) instead of permuting them; every class has p^d trees; the smallest classes are trees built on the base-p digits of m; a carry is a cherry collapsing, so their number is not divisible by p. | Brute force passes (47 cases). Three AI reviewers: proved, modulo write-up gaps; two steps were false as written and are being repaired (`paper/reviews/ADJUDICATION_round1.md`). **Not human-signed.** | briefing PDF; `paper/main.tex` |
| 2 | **"Every node is worth −p"** | Label the leaves: a tree has (m−1)/(p−1) nodes, each worth a factor −p; the m! labellings can absorb only the nodes of the "digit forest"; the t nodes left over are the valuation. In one line: C_n^(q)·∏ m_j! ≡ (−p)^t (mod p^(t+1)). | The congruence holds in 885 cases. Proof is a sketch; a worker is testing every lemma (W014). It passes through v_p(m!), derived by symmetry; whether that meets the brief is the humans' call. | `notes/2026-11-13_new_ideas.md`, Idea 1 |
| 3 | **The classes are known objects in chemistry and biology** | For p = 3 the rotation classes are exactly the stereoisomers of alkyl radicals C_nH_{2n+1} (a carbon's three other bonds can be rotated, not reflected). For p = 2 they are the shapes of evolutionary trees. | Sequence match checked in the OEIS (A000625, A001190). Deeper leads (a "symmetry nodes" balance index in phylogenetics) unverified; W016 is checking. | `notes/2026-11-13_new_ideas.md`, Idea 3 |
| 4 | **Sand on a ring versus sand on a line** | With the rule "p grains topple into one grain on the next site", v_p(C_n^(q)) = (topplings of m grains on a ring of k sites) − (topplings on a line). | The arithmetic identity is immediate; the meaning (each toppling is a cherry collapse worth −p) is being tested by W014. | `notes/2026-11-13_new_ideas.md`, Idea 2 |

## Tier 2 — one slide or one remark each

| # | Finding | Status | Where |
|---|---|---|---|
| 5 | **Where we stand against prior work.** For p = 2 the orbit argument with exactness is Deutsch–Sagan (and Postnikov–Sagan, weighted); Konvalinka uses the full symmetric group and gets divisibility only; Gao–Gu and Krattenthaler–Müller are algebraic. Not found in those texts: the p-group action for q = p^k, the digit skeleton with its depth condition, the carry–cherry count. | A worker read four full texts; this is **not** a novelty certificate. The professor's view is needed. | `references/overlap_fulltext.md`, `references/literature_scan.md` |
| 6 | **Refinements by other statistics** (asked for in the problem statement): p^t also divides the number of trees with a given height, level profile, and so on. | Running (W017, W003b). | — |
| 7 | **The weighted theorem with the smaller group** (Konvalinka's Theorem 5 without factorials). | Running (W003b). | CLAIMS C9 |
| 8 | **Frobenius view**: G = x + G^p; symmetric node = Frobenius, asymmetric node = p·δ; a one-page induction proof for q = p. | Running (W015). | `notes/2026-11-13_new_ideas.md`, Idea 4 |

## Tier 3 — parked unless something surprising comes back

- q not a prime power (W017, part B). Exploratory.
- A bijection between labelled cyclic p-ary trees and permutations made of p-cycles (W016).
- Residues modulo p² (data only).
- Three blind proof searches by different models (W018). Will be ranked here when they report.
- Statistical-physics partition function, information content, Kummer analogy (W013).

## Suggested shape of the 20 minutes

Finding 3 as the hook (2 min) → the statement and what was missing (3 min) → Finding 1, the proof (9 min) → Finding 2, the one-line reason (3 min) → Finding 5, honest position (1 min) → Findings 6–7 if signed (1 min) → how AI was used and checked (1 min).

## Verification at a glance

| Layer | State |
|---|---|
| Brute force by the author of the idea (E000) | passes |
| Independent code by another model (E001) | agrees, but only for k = 1 and small n; its two reported failures are a bug in its own handling of one-leaf trees |
| Large-scale stress test (E003) | running |
| Three adversarial AI reviews, round 1 | no counterexample; 14 write-up repairs accepted |
| Repair and second review round | running |
| Human sign-off | none yet |
