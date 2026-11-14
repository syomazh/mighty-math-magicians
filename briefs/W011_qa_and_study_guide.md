# W011 — Study guide for the presenters and a Q&A sheet

The judges will question the presenters orally. One presenter is a first-year undergraduate who must understand and defend every step. Write two documents that make that possible.

Read first: `notes/briefing_grad_student/briefing.tex` (authoritative for the mathematics), `CLAIMS.md`, `references/README.md`, `references/literature_scan.md` (headline and section 2 only).

## 1. `notes/study_guide.md`

A hands-on path through the argument for someone who knows what a group and a binary tree are, and nothing about p-adic valuations. Plain language, short sentences. Structure:

- "The whole proof in ten sentences."
- Vocabulary, each with a tiny example: p-adic valuation, base-p digit sum, carry, q-ary tree, leaf, complete tree, rotation, class, symmetric/asymmetric node, atom, skeleton, cherry.
- Fifteen exercises with full worked solutions, in increasing difficulty. Include at least: list the 5 binary trees with 3 nodes and sort them into rotation classes; do the same for the 14 with 4 nodes; compute d(T) and the class size for given trees; check C_n = Σ p^d for p = 2, n ≤ 5; find all minimal trees for p = 2, n = 6 and identify their atoms; the ternary cases n = 2 and n = 3; the case q = 4, n = 2 and n = 4 with the depth condition; add numbers in base p and count carries; perform the carry/cherry reduction by hand for a = (3) with p = 2, for a = (5) with p = 3, and for a = (2,1) with p = 2, k = 2; explain why the action of permuting equal atoms is free in one concrete example; explain why p must be prime in the class-size lemma by showing what goes wrong for "p = 4".
- "Five things people get wrong" (for example: confusing nodes with leaves; forgetting that classes, not trees, are being counted; thinking the group is all permutations).
- A one-minute and a five-minute spoken summary.

Every number in the guide must be recomputed by a script `notes/study_guide_check.py` (run with `uv run python notes/study_guide_check.py`), which prints each exercise's numerical answers; run it and make the guide agree with it.

## 2. `talk/QA.md`

At least 35 questions a judge might ask, grouped: motivation; the statement; each step of the proof; why this group and not Konvalinka's; what "combinatorial" means here and whether counting fixed points mod p qualifies; edge cases (q = 2, q = 3, n = 0, 1); generalizations; relation to Kummer's and Lucas' theorems; what is known in the literature; how AI was used and how the team verified the output; weaknesses and what is not proved. For each: an answer of two to four sentences that a first-year can say aloud, and where relevant a pointer to the exercise in the study guide that backs it. Mark with "(depends on unverified claim Cx)" any answer that relies on a claim not yet signed in `CLAIMS.md`. Include honest answers for the hard ones ("is this new?": we do not know yet; say what was checked).

Do not invent facts about the literature beyond what `references/` says. Touch only `notes/study_guide.md`, `notes/study_guide_check.py` and `talk/QA.md`.
