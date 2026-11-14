# Findings, ranked

_Maintained by the orchestrator (Claude Fable 5.2). Last updated 2026-11-14, Saturday morning (about 10:00 PT)._
_Purpose: one short page telling the humans what matters most. Details live in the linked files. Nothing here is human-signed unless it says so._

**If you read one thing:** the briefing PDF, `notes/briefing_grad_student/briefing_for_grad_student.pdf`. **To check the proof line by line:** `paper/main.pdf` (13 pages). **To learn it:** `notes/study_guide.md`.

**New on Saturday morning:** findings 6 (now a complete, self-contained second proof), 9 (the carry budget) and 10 (cross-field readings, ranked). The numbers of the older findings are unchanged.

## Tier 1 — the talk is built on these

| # | Finding | One-sentence version | Status | Where |
|---|---|---|---|---|
| 1 | **The main proof** | Rotate the children of each node (a p-group) instead of permuting them; every class has p^d trees; the smallest classes are trees built on the base-p digits of m; a carry is a cherry collapsing, so their number is not divisible by p. | Brute force passes. Stress test passes on 1067 values of m (up to 400 leaves, p ≤ 13, k ≤ 4). Three review rounds (three non-Claude models, then two fresh Claude referees) and one line-by-line read: no counterexample, no step needing a new idea; every defect found was repaired; the last repairs are not re-reviewed. The professor has so far found nothing wrong (reported Saturday morning; not a sign-off). **Not human-signed.** | `paper/main.pdf`; `paper/reviews/` |
| 9 | **The carry budget** (new) | Add up the leaves of a tree in base p, node by node: whatever its shape, you make (m − s)/(p − 1) carries; a symmetric node always makes at least one; so at least t nodes are asymmetric, and the minimal trees are those that waste no carry. | A three-line proof of Steps 2 and 3 from one identity, with no induction and no factorial (claim C19). Checked on all 1,978 classes with up to 13–19 leaves. The paper keeps its own (reviewed) proof; this is the version to *say*. An independent Claude referee found the mathematics correct (about 1.36 million classes and random trees up to millions of leaves, no violation); one wrong analogy sentence and a few gaps of statement were repaired (`paper/reviews/ADJUDICATION_carry_budget.md`). When saying it for p ≥ 3: a carry is one trade of p units for one, and a column can make several. | `notes/2026-11-14_carry_budget.md`; optional slide after "Step 2" |
| 6 | **A second proof by algebra alone ("Frobenius")** (rewritten) | Start from G = x + G^q only. Replace the p in "f^p = f(x^p) + p·(correction)" by a variable y; digit sums show that the lowest power of y is y^t; its coefficient obeys the same equation with a carry-free product; and a derivative identity modulo p gives the carry rule. | **Complete and self-contained** (claim C18): general q = p^k, with the residue, using no lemma of the main paper, no formula for the Fuss–Catalan numbers and no factorial valuation. Every lemma passes its own computer check (E010). An independent Claude referee found no error (details at the end of this file). It is algebra, not "symmetries of trees", so it is a check on the main proof and an explanation of it, not a replacement. | `paper/frobenius_proof.pdf` (9 pages); `experiments/E010_frobenius_complete` |
| 2 | **"Every node is worth −p"** | Label the leaves: a tree has (m−1)/(p−1) nodes, each worth a factor −p; the m! labellings can absorb only the nodes of the "digit forest"; the t nodes left over are the valuation. In one line: C_n^(q)·∏ m_j! ≡ (−p)^t (mod p^(t+1)). | Lemmas pass an independent check with explicit objects (E004). Write-up `paper/accounting_proof.pdf`; an independent Claude referee found it correct, small gaps repaired. It depends on the main paper's carry proposition and passes through v_p(m!); whether that meets the brief is the humans' call. | `paper/accounting_proof.pdf` |
| 3 | **The classes are known objects in chemistry and biology** | For p = 3 the rotation classes are the stereoisomers of alkyl radicals C_nH_(2n+1); for p = 2 they are the shapes of evolutionary trees. New: the link is quantitative. The symmetry group of a tree has order p^(number of symmetric nodes); the number of ternary trees with n nodes is prime to 3 exactly for the perfectly branched radicals (methyl, tert-butyl, …; 55 trees for n = 4). | Sequence match checked in the OEIS (A000625, A001190). The minimal trees for p = 2 are the "binary weight trees" of Kersting and Fischer (2021, full text read). The symmetry-group statement is checked on 1,030 classes (E011). | `references/cross_field_refs.md`; `notes/2026-11-14_crossfield_analogies.md`, A3 |
| 4 | **Sand on a ring versus sand on a line** | With the rule "p grains topple into one grain on the next site", v_p(C_n^(q)) = (topplings of m grains on a ring of k sites) − (topplings on a line). | Stated and proved as a proposition in `paper/accounting_proof.pdf`. Finding 9 is the same picture in its simplest form (a carry is a toppling). | `notes/2026-11-13_new_ideas.md`, Idea 2 |

## Tier 2 — one slide or one remark each

| # | Finding | Status | Where |
|---|---|---|---|
| 5 | **Where we stand against prior work.** For p = 2 the orbit argument with exactness is Deutsch–Sagan (and Postnikov–Sagan, weighted), and the minimal trees were found again by biologists (Kersting–Fischer 2021); Konvalinka uses the full symmetric group and gets divisibility only; Gao–Gu and Krattenthaler–Müller are algebraic (the latter expand the generating function in the series Σ x^(q^i), which is our series of atoms). Not found in those texts: the p-group action for q = p^k, the digit skeleton with its depth condition, the carry–cherry count. | A worker read four full texts; this is **not** a novelty certificate. The professor's view is needed. A web check on Saturday (keyword searches of OpenAlex, arXiv, the OEIS; `notes/2026-11-14_crossfield_literature.md`, item 8) found no proof of the valuation by a Frobenius lift or δ-rings, nothing linking it to heaps, counters or brackets, and nothing reading tree symmetries p-adically. It did confirm that the modulo-p starting point of finding 6 (the series Σ z^(p^n) and the relation Φ^p − Φ + z ≡ 0) is in Kauers–Krattenthaler–Müller (2012) and Krattenthaler–Müller (2025); they are now credited. A keyword search cannot establish novelty. | `references/overlap_fulltext.md` |
| 10 | **Cross-field readings, ranked** (new). (a) *Statistical physics:* Z_m(y) = Σ over classes of y^d gives the atoms at y = 0, the isomer count at y = 1 and the Fuss–Catalan number at y = p; p-adically y = p is small, so the valuation is the ground-state energy and the residue counts the ground states. Example: 429 = 1 + 4 + 56 + 112 + 192 + 64. (b) *p-adic analysis:* C_n^(q) = π^(m−1)/m! times an integer ≡ 1 (mod p), where π^(p−1) = −p is Dwork's constant. (c) *p-adic geometry:* C_n^(p) is the number of ways to cut Z_p into (p−1)n+1 balls. (d) *Group theory:* a tree is minimal exactly when its symmetry group is a Sylow p-subgroup of the symmetric group on its leaves. (e) *Everyday:* a knockout draw with m entrants has at least s_2(m) − 1 matches between differently shaped halves. | Each exact statement is checked (E011, E010); each item is labelled "exact" or "analogy" in the note. The statements about other fields were checked against sources by a Claude subagent (`notes/2026-11-14_crossfield_literature.md`; bibliographic data in `references/README.md`, entries 6–16); two of our wordings were corrected (symmetry numbers are group orders, a product only for independent rotors; the OEIS entry A001190 does not mention tournaments). **Question for the professor:** our residue formula, written as C ≡ π^(s−1)/∏ m_j!, has the shape of Stickelberger's congruence for Gauss sums (note B1′). Known link, or coincidence? | `notes/2026-11-14_crossfield_analogies.md` |
| 7 | **Refinement by level profile** (the problem statement asks for "other statistics"): for every way of fixing the number of nodes at each depth, the number of trees is still divisible by p^t. Arithmetically: p^t divides ∏ binom(q·n_i, n_(i+1)). | Holds for every profile tested (n up to 22 for q = 2, up to 12–15 for q = 3, 4, 5, 8, 9). Follows from finding 1 once signed. | `experiments/E002_extensions/` |
| 8 | **The weighted theorem with the smaller group** (Konvalinka's Theorem 5 without factorials). | Numerically supported for 6 values of q and 4 weight functions each, no failures; a control with a non-transitive group fails, as predicted. Not written up. | `experiments/E002_extensions/` |

## Tier 3 — parked

- Other closed families (bounded height, all leaves deep): divisibility holds in all tested cases.
- A bijection between labelled cyclic p-ary trees and permutations made of p-cycles: holds in every case tested (E009; p = 2, 3, 5).
- q not a prime power: not explored.
- Residues modulo p²: data only.
- An observation from the data: for binary trees the number of level profiles with valuation exactly t is 1, 3, 13 for t = 1, 2, 3. These look like the ordered Bell numbers. Unexplained.
- Renormalisation, necklaces and operator language for the Frobenius proof: see Tier C of the cross-field note.
- The first Frobenius draft by a worker (`paper/alt_proof_frobenius.tex`, four marked gaps, q = p only) is superseded by finding 6.

## Suggested shape of the 20 minutes

Finding 3 as the hook, with the tert-butyl example (2 min) → the statement and what was missing (3 min) → Finding 1, the proof, with Step 2 told as the carry budget of Finding 9 (9 min) → "we proved it twice": Finding 6 in one slide, with 429 = 1 + 4 + 56 + … as the picture (3 min) → Finding 5, honest position (1 min) → Findings 7–8 if signed (1 min) → how AI was used and checked (1 min). Findings 2, 4 and 10(b)–(e) are answers for the question session.

## Verification at a glance

| Layer | State |
|---|---|
| Brute force by the author of the idea (E000) | passes |
| Independent code by another model (E001) | agrees for k = 1, small n only |
| Large-scale stress test, no assumptions (E003) | passes: 1067 values of m, p ≤ 13, k ≤ 4 |
| Three adversarial AI reviews, round 1 | no counterexample; 14 write-up repairs |
| Orchestrator's line-by-line check after repair | 4 further defects found and fixed |
| Independent Claude referee, round 2 | proved modulo gaps; 10 repairs made |
| Third pass on the repaired text | proved modulo small gaps; 13 repairs made; those repairs not re-reviewed |
| A second, independent proof of the same theorem (finding 6) | written; every lemma checked by computer (E010); one independent referee found no error, 12 small repairs made |
| Human sign-off | **none yet**; the professor has found nothing wrong so far |

**Referee of the Frobenius note (done 09:51):** an independent Claude reader who saw only the note found no false statement and no invalid step, and reproduced every numbered statement with its own code. It listed 5 omitted justifications and 7 points of wording; all are repaired (`paper/reviews/ADJUDICATION_frobenius.md`). The repairs are not re-reviewed, and the referee is the same model as the author; a human read is still needed.
