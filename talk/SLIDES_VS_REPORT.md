# The two slide decks against the report

Written by Claude Fable 5.2 (AI; a fresh-context agent, brief `briefs/W054_slides_vs_report.md`), 2026-11-15. Not human-reviewed. This file is a check: nothing else was changed (not the decks, not the report).

**The rule being checked** (`SUBMISSION_RULES.md`): everything on the slides must also be in the report; what is only on a slide is judged by the human judges only.

**What was compared.**
- The report: `report/report.tex` as it stood at 03:42 (77 pages). Section, theorem and page numbers below are those of the PDF; "search" gives a phrase of the source file.
- **Deck A**, the teammate's deck: `talk/Fuss–Catalan valuations from rotations of trees.pdf`, 16 slides, no source. Read as page images and as text.
- **Deck B**, the AI-written deck: `talk/slides.tex` and `talk/slides.pdf` in the working copy, 34 pages, with the figures of `talk/figures/`. Page 27, "How the AI team worked", is **uncommitted**: it exists only as a local change to `talk/slides.tex` and `talk/slides.pdf` (and as a standalone copy in an untracked folder at the repository root; the two frames are identical). The committed deck has 33 pages; its pages 27 to 33 are pages 28 to 34 here.
- The record: `CLAIMS.md` (latest entries), `notes/2026-11-15_review_rotors_and_guest_notes.md` section 8, `report/NOTES.md`, `MORNING_BRIEF.md` item 3, `AI_USAGE.md`, `logs/delegations/INDEX.md`, `references/README.md`.

**Marks.** A-M*n*, B-M*n*: must change before presenting (wrong, or contradicting the report). A-R*n*, B-R*n*: on the slide and not in the report (add to the report, or drop from the slide). P1, L-…: sentences ready to paste, in the last section. [high], [medium], [low] say how much an item matters.

**Numbers recomputed for this file** (two scripts of mine, run with `uv run python`, not kept in the repository): the table of Catalan numbers; the five values of the theorem (132, 43263, 140, 117, 29799) with their residues; C_12 = 208012; all class sizes quoted on a slide (5 = 1 + 4; 14 = 2 + 4 + 8; 132 = 12 + 24 + 64 + 32 in 11 classes; 12 = 3 + 9; 55 = 1 + 9 + 9 + 9 + 27; 22 = 2 + 4 + 16); the numbers of classes of ternary trees 1, 1, 2, 5, 11, 28; T(5) = 40 with 36 trees moved in 12 orbits and 4 fixed; T(3, 2) = 4, T(0, 3) = 2, T(1, 0) = 1; T(1), T(2), T(3) = 1, 1, 3; the orbit sizes 1, 4, 6, 12, 24 and 1, 2, 4, 8; the sum 3/16 + 3/8 + 4/4 + 1/2 = 33/16; both bar charts; the two trees of the carry-budget figure; the sand example; the bound for mixing steps (m ≤ 16) and "first at m = 15" (m ≤ 20); 39 = 1110 in base 3. **Every number on both decks that I could recompute is right.** Not recomputed (taken from the ledger): 1067 leaf counts, the counts of defects 14, 4, 10, 13, the ranges of the level profiles.

---

## Deck A (the teammate's deck, 16 slides)

### Verdict

1. **Not as it is, but it is close.** Every statement but one is in the report, most of them nearly word for word; the report was assembled with this deck open.
2. One statement is shown as a fact and is listed in the report as "not proved": the "only if" half of the equivalence on slide 12. One symbol on the slide, or the three-line proof P1 in the report, settles it.
3. Slide 15 contradicts Section 1.4 of the report in its three bullets "New here", and its status line is out of date and names a "line-by-line human review" that is not on record.
4. Three smaller points of wording: slide 2 (the residue credited to Konvalinka), slide 11 ("exactly when"), slide 15 ("Petersen, Touchard").
5. The deck has no word on AI, on Lean or on what a human has read. The rule does not ask for it; the judges are told to ask, and page 1 of the report says that the proofs were found and written by AI systems.

### Slide by slide

| Slide | On the slide | In the report | Agrees? |
|---|---|---|---|
| 1 | Title "Fuss–Catalan numbers mod p, from rotations of trees"; "the exact power of a prime p dividing the number of q-ary trees, q = p^k, proved from the symmetries of trees and without factorial valuations"; the team name | Abstract; "The result on one page"; Theorem 3.1 | Yes. The report adds "apart from the trivial fact that a! is prime to p when a < p" (§2.1). The team name is on this slide and in every footer; in the report it may stand in the title block only. |
| 2 | Formula for C_n^(q) as the number of "planar" q-ary trees with n internal nodes; q = p^k, m = (q − 1)n + 1 leaves, digits m_j, s_p(m), t | §1.1, search "the Fuss--Catalan number"; §2.1, "Throughout" | Yes (the report says "plane"). |
| 2 | p^t divides C and C/p^t ≡ (−1)^t/∏ m_j! (mod p) | Theorem 3.1; §2.1 "Main theorem" | Yes. |
| 2 | "Known: Konvalinka (2007), via Legendre's formula for the power of p in N!" (under both formulas) | §1.2, "Proposition~2 of that paper"; "Remark~3 gives, for"; "as a statement, a consequence of a classical congruence" | **In part.** In the report the valuation is Konvalinka's Proposition 2, by Legendre's formula; the residue is in his Remark 3 for q = p only, and for prime powers it follows from the congruence of Anton, Stickelberger and Hensel. → A-M4 |
| 2 | "Problem 137: prove it from the symmetries of trees, without factorial valuations" | §1.3, "Problem~137 asks whether" | Yes. |
| 3 | "Konvalinka lets the full symmetric group act …: orbit sizes are products of multinomials, and the argument stops at divisibility" | §1.2, "Proposition~7 states"; §1.3, "is not a $p$-group" | Yes. |
| 3 | "We keep only cyclic rotations, a Sylow p-subgroup. Then every orbit has p-power size, and the smallest orbits can be counted mod p." | Remark 3.6, "iterated wreath product"; §5 item 2; Lemma 3.12; Propositions 3.23, 3.25 | Yes. For k ≥ 2 say "rotations at each of the k levels": the group is not the cyclic shifts of the q children (§4.5, "does not contain the shift"). |
| 3 | The list of steps 1, 2, 3–4, 5, 6, 7 | §2.1, Steps 0 to 4 | Content yes; **the numbers differ.** → A-R2 |
| 4 | "Each q-ary node becomes a complete p-ary tree of height k"; "cutting at depths 0, k, 2k, … recovers the q-ary tree" | Lemma 3.4 (Blocked form) and its proof | Yes. |
| 4 | Picture: a 4-ary tree with n = 3 (first and fourth child of the root internal) and its binary form with 10 leaves at depths 2 and 4 | §2.2, "A prime power" has q = 4, n = 3 in words (22 trees, "depths $2$ and $4$ for six of them"); this tree is not described | Yes (it is one of the six). → A-R4, optional. In the picture "d = 0, 2, 4" means depth; from slide 5 on, d(T) is the number of asymmetric nodes. |
| 5 | Rotation; symmetric (S) and asymmetric (A) nodes; d(T); C = Σ over rotation classes of p^d(T) | Definitions 3.5, 3.9; Lemma 3.12; §2.1 Step 1 | Yes. |
| 5 | Picture: T = ((•,(•,•)),((•,•),•)), d(T) = 2, its class of 4 trees; "the root is symmetric although its subtrees differ" | §2.2, "A symmetric node with different-looking subtrees" | Yes, the same tree. |
| 6 | s_p(pu) = s_p(u); s_p(u_1 + … + u_p) ≤ Σ s_p(u_i), equality iff no carries | Lemma 3.13 | Yes. |
| 6 | d(T) ≥ t(m); the two cases of the induction with their cases of equality | Propositions 3.14, 3.15 | Yes. (The slide writes m_1, …, m_p for the leaf counts of the subtrees; on slide 2 m_j are the digits. The report writes a_i.) |
| 6 | "d(T) ≥ t for every T ⟹ p^t divides C. This is the divisibility Konvalinka obtains from a larger group action." | §2.1 Step 2; §1.2 | Yes. |
| 7 | "T is minimal exactly when (a) every node is asymmetric or roots a complete subtree, and (b) at asymmetric nodes the leaf counts add without carries" | Proposition 3.15 (the same, said recursively); proof of Proposition 3.19, first lines; §4.4, Consequence (2) | Yes. |
| 7 | C/p^t ≡ N_min (mod p) | Equation (3.8); §2.1 Step 2 | Yes. |
| 7 | Four pictures: 6 leaves, minimal (d = 1) and "fails (a)" (d = 2); 5 leaves, minimal ("1 + 4 = 001_2 + 100_2, no carry") and "fails (b): 2 + 3 = 10_2 + 11_2 carries; d = 2" | §2.2, "A symmetric node with different-looking subtrees" and "Five leaves" | Yes; all four trees are in the report in bracket notation. |
| 8 | "A minimal tree is a skeleton of t asymmetric nodes carrying complete subtrees, the atoms … exactly m_j atoms of height j … s_p(m) atoms in all" | Proposition 3.19; Definition 3.16 | Yes. |
| 8 | "N_min = \|S(m, k)\|: skeletons with m_j leaves labelled j, children taken up to cyclic rotation at every node; a leaf labelled j sits at depth ≡ −j (mod k)" | Definition 3.16, condition (S); Proposition 3.19 | Yes; **the symbol S(m, k) is not in the report.** → A-R1 |
| 8 | Example q = 3, n = 8, m = 17 = 122_3, atoms of sizes 9, 3, 3, 1, 1; picture of a minimal tree and of its skeleton (1, 2, (0, 0, 1)) | Example 3.29: the first pictured skeleton, ((K_0, K_0′, K_1), K_1′, K_2), is the same cyclic tree | Yes. |
| 8 | "root adds 3 + 9 + 5 = 010_3 + 100_3 + 012_3 with no carry" | **Not in the report** | Correct. → A-R3 |
| 9 | Distinct labels; a label's class is its height mod k; T(a); a_i = Σ over j ≡ i of m_j | §3.5.1, search "Make all these atoms distinct" | Yes. On the slide T(a) is a set and \|T(a)\| its size; in the report T(a) is the number. → A-R1 |
| 9 | \|T(a)\| = ∏ m_j! · \|S(m, k)\|; "permuting equal-height labels is a free action: its order is prime to p, while symmetries of a cyclic tree have p-power order" | Proposition 3.21 with Lemma 3.20 (ii) | Yes (the lemma says: an automorphism of order prime to p is the identity; that is equivalent). |
| 9 | "q = 3, n = 8: \|T(5)\| = 40 = 2!·2!·1!·10" | §2.2, "Labelled skeletons and carries"; Example 3.29 | Yes (recomputed). |
| 10 | The p-cycle σ on p labels of one class; "\|T(a)\| ≡ \|Fix(σ)\| (mod p)" | Equation (3.3); proof of Proposition 3.23 | Yes. |
| 10 | "36 of the 40 trees move, in 12 orbits of size 3" | §2.2, search "moves $36$ of these $40$ trees" | Yes (recomputed). |
| 10 | Picture: one orbit of three trees | **Not described in the report** | Correct (checked). → A-R5, optional |
| 11 | "σ fixes a tree exactly when the labels x_1, …, x_p form a cherry, and its action is one of the p − 1 non-trivial powers of the rotation of that cherry" | Proposition 3.23 ("in one of p − 1 cyclic orders"); Lemma 3.22 | **Only if both conditions are read inside "exactly when".** Read as "fixed ⟺ the labels form a cherry" it is false for p ≥ 5: of the (p − 1)! cyclic orders of the labels only p − 1 are fixed (4 of 24 for p = 5; `CLAIMS.md`, C23 (b); recomputed). The picture has p = 3, where (p − 1)! = p − 1. → A-M5 |
| 11 | Picture: the four fixed trees for p = 3 and the two trees after the collapse; "collapsing the cherry removes p leaves of class c and adds one leaf of class c + 1 (mod k), one level closer to the root"; the congruence \|T(a)\| ≡ −\|T(a − p·e_c + e_(c+1))\| | Proposition 3.23; §2.2, "fixes $4=(p-1)\cdot T(3)$" | Yes (recomputed: exactly these four). The list of the four trees is not in the report. → A-R5, optional |
| 12 | "T(a) ≠ ∅ ⟺ a ≠ 0 and Σ a_c p^c ≡ 1 (mod q − 1)" | "⟸": §2.2, "In general, if" (Proposition 3.25; Lemma C.2). "⟹": §2.2, "The converse, that no such tree exists"; status table, row "A converse (on the slides": **"Not proved in this report"** | **The slide states as a fact what the report lists as not proved.** → A-M1. The statement is true in the 1041 label vectors I computed, and has a three-line proof (P1). |
| 12 | "then \|T(a)\| ≡ (−1)^r (mod p)" | Lemma C.2; Proposition 3.25 (there r = t) | Yes; **r is not defined on the slide** (r = (Σ a_c − 1)/(p − 1), the number of carries). |
| 12 | Picture: T(3, 2): 4 trees; T(0, 3): 2 trees; T(1, 0): 1 tree | §2.2, search "$T(3,2)=4$" (p = 3, k = 2) | Yes (recomputed). The slide does not say that p = 3 and k = 2. |
| 13 | The chain C/p^t ≡ N_min = \|S(m, k)\| = \|T(a)\|/∏ m_j! ≡ (−1)^t/∏ m_j!; "the right side is nonzero mod p" | Proof of Theorem 3.1 | Yes. |
| 13 | Table: (2, 6) 132 = 2²·33; (3, 8) 43263 = 3²·4807; (9, 3) 117 = 3²·13; (9, 5) 29799 = 3²·3311; residues 1, 1, 1, 2 | §2.2, "Values of the theorem" (these four rows and one more) | Yes (recomputed). |
| 14 | "Label all m leaves …"; m!·C = p^N(m)·L(m), L(m) ≡ (−1)^N(m); m! = p^ν(m)·∏ m_j!·\|F(m)\|, \|F(m)\| ≡ (−1)^ν(m); t = N(m) − ν(m) | §4.3; Lemmas C.3, C.4, C.5 | Yes. |
| 14 | "Sandpile picture: … a ring of k sites takes N(m) topplings and a half-line takes ν(m). The exponent t is the difference." | Appendix C, the last proposition, search "On the half-line of sites"; §5 item 11 | Yes. |
| 14 | "This route needs the power of p in m! (proved by the same collapse), so we present it as a remark, not as the proof." | §4.3, "What it does not do" | Yes. In the report this proof is "read by a faculty member, not signed". |
| 15 | Known: Etherington (1939), 2^d ordered versions; Deutsch–Sagan (2006), the orbit proof with exactness for p = 2, (2s − 3)!! minimal orbits; Kersting–Fischer (2021), the same minimal binary trees | §1.2, "The case $p=q=2$"; §3.1 | Yes. |
| 15 | Known: "Petersen, Touchard: count fixed points of a p-cycle, collapse the fixed block" | §1.4, "The fixed-point principle of the last step" | **In part.** The report has Petersen (1872; Fermat's and Wilson's theorems) and a proof of Touchard's congruence by a p-cycle, both as recorded from slides of Gessel (2010); it does not say that Touchard argued this way, and Petersen's paper was not located. → A-M6 |
| 15 | The column "Known" has no line for Konvalinka | §1.4, first item of "Not claimed" | Missing: the formula, the divisibility by a group action, the shape of the smallest orbits (Lemmas 8 to 10), and the residue as a classical statement. → A-M2 |
| 15 | New: "The rotation (Sylow) group for every prime p and every q = p^k" | §1.4, "the \emph{use}, for this theorem"; "not new as objects" | **Contradicts** unless it says "the use of". → A-M2 |
| 15 | New: "Minimal trees are skeletons on the digits of m, with a depth condition" | §1.4, "the \emph{shape} of this description is not new" | **Contradicts**: the shape is Konvalinka's Lemmas 8 to 10 (base q, full group); for p = 2 it is in Deutsch–Sagan and Kersting–Fischer. → A-M2 |
| 15 | New: "The cherry collapse is a carry mod q − 1: exact valuation and residue, no factorial valuations" | §1.4, third item of "Claimed"; "and the residue formula as a statement" | The count by collapsing cherries is claimed; **the two formulas are not new as statements.** → A-M2 |
| 15 | "New here, as far as we found" | §1.4, "as far as we know" | Yes. |
| 15 | "Status: every lemma checked by computer on all small cases; the proofs are under line-by-line human review." | §2.3, row "C1--C8 as a whole"; §7.1; §9.3 | **Out of date, and more than the record** on the human side. → A-M3 |
| 16 | "Every orbit has p-power size; the smallest ones are counted by collapsing cherries." | §2.1, "In one sentence: shrink" | Yes. |

### Must change before presenting (6)

- **A-M1 [high]. Slide 12, "⟺".** Smallest fix on the slide: replace "⟺" by "⟸" (and write the line as "if a ≠ 0 and Σ a_c p^c ≡ 1 (mod q − 1), then T(a) ≠ ∅ and |T(a)| ≡ (−1)^r"). Or keep the slide and paste P1 into the report (then the sentence of §2.2 and one row of the status table change with it; P1 says how). On the same slide: say what r is, and that the picture has p = 3, k = 2.
- **A-M2 [high]. Slide 15, the box "New here".** Suggested text, in the report's words: "Using cyclic rotations (a p-group) for this theorem, for every prime p and every q = p^k" / "The smallest classes in base p with a depth condition (their shape is Konvalinka's Lemmas 8–10; for p = 2 Deutsch–Sagan)" / "Counting them mod p by collapsing cherries: a proof of exactness and of the residue from tree symmetries". And one more line under "Known": "Konvalinka (2007): the formula, divisibility by a group action; the residue is a classical congruence for binomial coefficients".
- **A-M3 [high]. Slide 15, the status line.** Replace by what the report says: "Main proof: looked through and approved by a faculty member of the team; formalized in Lean 4 (no `sorry`); no failure in 1067 leaf counts." "Line-by-line human review" is not on record: the ledger has "looked through the main proof and said it is good".
- **A-M4 [medium]. Slide 2, the box "Known".** Smallest fix: "Known: the valuation, Konvalinka (2007), via Legendre's formula; the residue follows from a classical congruence for binomial coefficients."
- **A-M5 [low]. Slide 11, first sentence.** Smallest fix: "σ fixes a tree only if x_1, …, x_p form a cherry; of the cyclic orders of the labels in the cherry exactly p − 1 are fixed."
- **A-M6 [low]. Slide 15, "Petersen, Touchard".** Smallest fix: "Petersen (1872), and Touchard's congruence as proved in Gessel's slides (2010): …".

### Add to the report or drop from the slide (5, and the report side of A-M1)

- **A-R1. The symbols S(m, k) and the set T(a)** (slides 8, 9, 11, 12, 13). Add L-A1 to the report, or say "N_min" and "the number T(a)" on the slides.
- **A-R2. The step numbers 1 to 7** (slides 3 to 13) against Steps 0 to 4 of the report. Add L-A2, or renumber the slides.
- **A-R3. Slide 8, "root adds 3 + 9 + 5 = 010_3 + 100_3 + 012_3 with no carry".** Add L-A3, or drop the clause.
- **A-R4 (optional). Slide 4, the pictured tree.** Add L-A4.
- **A-R5 (optional). Slides 10 and 11, the pictured orbit and the four fixed trees.** Add L-A5.
- (Report side of A-M1: P1.)

If deck A is chosen, five sentences of the report that speak of "the slides" describe deck B and should be reworded (see "Notes on the report", 3).

---

## Deck B (the AI-written deck, 34 pages, one of them uncommitted)

### Verdict

1. **No.** Fifteen places must change, seven of them serious; seventeen items are on a slide and not in the report, most of them in figure captions and on the six backup slides.
2. Serious: a citation that is in no reference list (page 28); "Ours: the residue for all prime powers", which the report disclaims (page 28); "asymmetric carbon" in the butyl figure, which the chemistry review and the report itself say not to use (page 6); two results shown as conjectures that the report proves (page 22); a placeholder "to be filled in" and wrong credits on the AI slide (page 26); and the workflow slide (page 27, uncommitted), which claims more review than the record shows.
3. The mathematics agrees with the report everywhere I could recompute it, on all 34 pages.
4. The deck is older than the report and mostly understates: "candidate proof, under verification" on nine pages, "Claim" for the theorem, "not yet proved", Lean for one proof. That is not an integrity risk, but a judge who reads the report afterwards finds two accounts of the status.
5. Cheapest route if this deck is chosen: fix B-M1 to B-M7, set the two status switches, cut the six backup slides or paste L-B12 to L-B17 into Section 5 of the report, and regenerate one figure.

### Slide by slide

| Page | On the slide | In the report | Agrees? |
|---|---|---|---|
| 1 | Title, date, the team name; motto "A counting fact deserves a counting proof." | Title, abstract | Yes; the motto is not in the report and claims nothing. |
| 2 | Table n = 1 to 8 of C_n, n + 1 in binary, v_2; "the number of 1-bits of n + 1, minus one"; "odd exactly when n + 1 is a power of 2" | §1.1, "The pattern is visible in the first Catalan numbers" | Yes (recomputed). |
| 3 | Two bar charts: the power of 2 in C_n for n = 1 to 64 ("odd exactly at n = 2^j − 1") and the power of 3 in the number of ternary trees for n = 1 to 41 ("prime to 3 exactly at n = (3^j − 1)/2") | The two facts: §1.1; §5 item 3, "$n=1,4,13,40,\dots$". **The charts are not in the report.** | Correct (recomputed). → B-R1 |
| 3 | "The power of p is (digit sum of the number of leaves in base p − 1)/(p − 1). This is known, by computing with factorials. Why should the digits of a number have anything to do with trees?" | §1.1, "Theorem (known; Konvalinka"; §1.3 | Yes. |
| 4 | Figure: one mobile with 5 leaves and 2 lopsided bars, four photographs; the text "Every bar can spin … That is the plan of the proof." | §5 item 4 (nearly word for word); the tree is the class of size 4 of §2.2, "Five leaves" | Yes. The report adds that the picture fails for a prime power. |
| 5 | Figure: one tree with 6 leaves drawn four times: six species A to F; six players; the code words 00, 01, 100, 101, 110, 111; notes 1/4, 1/4, 1/8, 1/8, 1/8, 1/8 | §5 item 1, "One tree with $6$ leaves can be drawn as". **The details of the four drawings are not in the report.** | Yes. → B-R2 |
| 5 | "Only the shape counts. How many ordered trees stand over one shape? Always a power of 2. The smallest power that occurs is the power of 2 in the Catalan number."; "6 = 110_2: one node has to be lopsided, and one is enough"; "Biologists count these nodes … (Kersting–Fischer 2021)" | §5, first paragraph and item 1 | Yes (source opened by AI only, as the report says). |
| 6 | Figure: the five butyl groups; **legend "symmetric carbon", "asymmetric carbon"; "0, 2, 2, 2, 3 asymmetric"**; 3^0 = 1, 3² = 9 (three times), 3³ = 27 trees; "1 + 9 + 9 + 9 + 27 = 55 … Not divisible by 3, because tert-butyl is alone in its class." | §5 item 3; §2.2, "An odd prime" | Numbers yes (recomputed). **"Asymmetric carbon" is first on the chemistry review's list of sentences not to say, and §5 item 3 says the word should be "lopsided".** → B-M3 |
| 6 | "The three further bonds of a carbon atom can be rotated, not reflected: a cyclic group of order 3 at every node. Ternary trees up to rotation are the alkyl groups, mirror images counted separately: 1, 1, 2, 5, 11, 28, … (OEIS A000625)." | §5 item 3 | Yes; this is the review's first safe sentence. Nothing else on the review's list is on the deck: no symmetry numbers, no "radicals", no NMR, no "55 conformations", no polymer ratio, no Flory. |
| 7 | Definition of a q-ary tree; the formula; "Known (Konvalinka 2007, via factorials)" for the valuation; "Problem 137" | §1.1; §1.2 | Yes. |
| 8 | Left: all permutations, orbit sizes products of multinomial coefficients, divisibility, "exactness still quoted from factorials". Right: "Only rotations — our change", orbit sizes powers of p, "a p-group (Sylow p-subgroup of S_q)", "minimal orbits can be listed and counted mod p" | §1.2; §1.3 (the table, "group at a node"); Remark 3.6 | Yes. "Our change" is the use of rotations for this theorem; the classes are known objects (§1.4). |
| 8, 13, 15–21 | Footer "candidate proof, under verification"; the word "Claim" in four blocks (pages 13, 14, 16, 20) | §2.3: Theorem 3.1, approved by a faculty member, checked by Lean | **Out of date.** → B-M8 |
| 9 | Figure: one node with 4 branches, "24 moves; classes of 1, 4, 6, 12 or 24; 6 and 12 are not powers of 2"; two levels of nodes with 2 branches, "8 moves; classes of 1, 2, 4 or 8" | §5 item 5, search "sizes such as $6$ and $12$" | Yes (recomputed). The list 1, 4, 6, 12, 24 is not in the report. → B-R3 |
| 10 | Figure: families of 2 ("opposite quarters cut"), 4 ("neighbouring quarters cut") and 16 ("a quarter cut, and a quarter of it cut again"); 22 = 2 + 4 + 16; "smallest family: 2^1 so 22 = 2 × 11"; "10 cells, 10 = 1010_2" | §5 item 5; §2.2, "A prime power". **Which pictures form which family is not in the report.** | Yes (recomputed). → B-R4 |
| 10 | "The 8 symmetries of a square permute its four quarters and keep the diagonals together: exactly our group for a node with four branches. …" | §5 item 5 | Yes. |
| 11 | Step 0: the picture; the bijection; the leaf count | Lemma 3.4 | Yes. |
| 11 | "The answer can only depend on m." | **Not in the report** | Not justified at this step: the set of trees depends on k as well. It is true only after the theorem (t depends on p and m). → B-M12 |
| 12 | Step 1: rotation, "(A, B, A) → (A, A, B) → (B, A, A), orbit size 3"; "generates a p-group"; "rotations preserve leaf depths"; the key definition | Definitions 3.5, 3.9; Remark 3.6; Lemmas 3.8, 3.11 | Yes. |
| 13 | "\|[T]\| = p^d(T), by induction: the p rotations of a word of length p are all equal or pairwise distinct, because p is prime"; C = Σ p^d; C/p^(min d) ≡ N_min | Lemmas 3.11, 3.12; equation (3.8) | Yes. |
| 14 | Step 2: the lower bound and its induction; "Konvalinka's divisibility, now a five-line induction" | Lemma 3.13; Proposition 3.14 | Yes. |
| 15 | Figure: two trees with 7 leaves with their carries: "4 carries in all, none wasted, 2 asymmetric nodes (the minimum, t = 2)" and "4 carries in all, 3 wasted at asymmetric nodes, 5 asymmetric nodes" | The statements: §4.4, Facts 1 to 3. **The example with 7 leaves is not in the report** (its example has 13 leaves). | Correct (recomputed). → B-R5 |
| 15 | The text: ν(m); "a symmetric node always makes at least one"; d(T) ≥ (m − 1)/(p − 1) − ν(m) = t | §4.4 | Yes. Status in the report: one AI referee and Lean; no human reader. |
| 16 | Step 3: minimal trees; the atoms are the digits; "Claim (skeleton bijection)" | Propositions 3.15, 3.19 | Yes. |
| 17 | Figure: 13 = 8 + 4 + 1 = 1101_2; "The most symmetric tree with 13 leaves has 12 nodes: 10 symmetric … 2 asymmetric"; "2 = (number of ones in 1101) − 1" | §5 item 6; §4.4, "has $12$ nodes and makes $10$ carries" | Yes, except "the": there are three such trees (computed). The report has the same wording. → B-M15 |
| 17 | "= the power of 2 in C_12 = 208012" | **The number 208012 is not in the report** | Correct (208012 = 4 · 52003). → B-R6 |
| 18 | C_6 = 132 = 2²·33, m = 7 = 111_2, t = 2; the three minimal skeletons; "11 rotation classes in all, N_min = 3 (odd)" | Example 3.28; §2.2, "Seven leaves" | Yes (recomputed). |
| 18 | "Each class has 2² = 4 trees; together 132 = 4·33." | — | **Misleading:** the three classes hold 12 trees; 132 is the number of all trees. → B-M10 |
| 18 | "These are the rooted phylogenetic trees on the three 1-bits of 7." | **Not in the report in these words** | True. → B-R7 |
| 19 | Step 4: the fixed-point count; the cherry; "(p − 1) cyclic orders ⇒ one factor −1"; 10_2 + 10_2 = 100_2; T(a) ≡ −T(a − p·e_c + e_(c+1)); T(a) ≡ (−1)^t | Propositions 3.23, 3.25 | Yes. |
| 19 | "Running example: T(3) ≡ −T(2) ≡ T(1) = 1, and indeed T(3) = 3." | **This chain is not in the report** (Example 3.28 has N_min = 3) | Correct (recomputed). → B-R8 |
| 20 | "Claim (main statement)": valuation and residue; "No valuation of a factorial, binomial or multinomial is used." | Theorem 3.1; §2.1 | Yes. |
| 21 | q = 4, n = 4: 140 = 2²·35, m = 13 = 1101_2, one skeleton, the carries (2, 1) → (0, 2) → (1, 0), N_min = 1 | Example 3.30 | Yes (recomputed). |
| 22 | Header "checked numerically, not yet proved"; weighted numbers "(conjecture C9)" | §4.5, search "a conjecture. What follows"; §2.3, row "C9. Weighted numbers" | Yes for C9. |
| 22 | "Level profiles … p^t should divide ∏ binom(q·n_i, n_(i+1)) … (conjecture C10)" | §4.5, "Level profiles": a corollary with proof; §2.3, row "C10. Level profiles": proved in the report, Lean | **Contradicts the report.** → B-M4 |
| 22 | "Any closed family … (conjecture C11)"; "Not claimed as theorems today." | §4.5, "Closed families": a proposition with proof; §2.3, row "C11. Closed families" | **Contradicts the report.** → B-M4 |
| 22 | "every level profile up to 22 nodes for q = 2 (up to 12–15 for q = 3, 4, 5, 8, 9); weighted numbers for six values of q" | §6, row E002 | Yes. |
| 23 | Figure: the 11 shapes with 7 leaves by d: 1 × 2^5, 4 × 2^4, 3 × 2^3, 3 × 2^2; 132 = 12 + 24 + 64 + 32; the text on ground states | §5 item 7; §2.2, "Seven leaves" | Yes (recomputed). |
| 23 | "For p = 2 this is literal: … tree diagrams of a cubic field theory, each divided by its symmetry factor …: 3/16 + 3/8 + 4/4 + 1/2 = 33/16, and 16 is the largest symmetry factor." | §5 item 7, tagged "analogy over exact arithmetic"; "depends on writing the coupling as $g/3!$" | Numbers yes. "Literal" is stronger than the report. → B-M13 |
| 24 | Header "checked by computer and by AI referees, not yet by us"; title "Two more proofs" | §2.3, rows "C18" and "C13, C14"; §4: three further proofs | **Out of date:** the algebraic proof is checked by Lean in full and has no human reader; the accounting proof was read by a faculty member, not signed; the lattice-path proof, the one a human read and verified, is not on the deck. → B-M9 |
| 24 | Algebra: G = x + G^q; f^p = f(x^p) + p·θ(f); F = x + F(x^p, y^p) + y·θ(F); y = p, y = 1, y = 0; "(For p = 2 this equation is Etherington's, 1939.)"; "it shares no lemma with the main proof" | §4.2 | Yes. "y marks asymmetric nodes" and "y = 1: shapes" are, in the report, a dictionary "confirmed by computation only" and not used in the proof. |
| 24 | Accounting: "each of the (m − 1)/(p − 1) nodes is worth −p, and m! absorbs (m − s_p(m))/(p − 1) of them"; C·∏ m_j! ≡ (−p)^t (mod p^(t+1)) | §4.3; Theorem C.1 | Yes. |
| 25 | "Shrink the symmetry group until it is a p-group. Then orbit sizes are powers of p, the smallest orbits are built from the digits of m, and a carry in base p is a cherry collapsing." | §2.1, "In one sentence: shrink" | Yes. |
| 25 | "Exactness — not just divisibility — comes free." | **Not in the report** | Rhetoric; exactness is what Step 4 pays for. → B-R9 |
| 26 | "The idea and the proof sketch: Claude Fable 5.2 (orchestrator)." | §9.1, first row | Yes. |
| 26 | "Writing: the full LaTeX proof and these slides by Kimi K3.1 Pro (Open Math OS); independent re-check, literature scan, explainer and further drafts by other logged worker models (Mistral Large 4.0, Muse Spark Open, DeepSeek Flash)." | §9.1; `logs/delegations/INDEX.md` | **Contradicts the report and the log.** → B-M6. "Explainer" is not in the report. → B-R10 |
| 26 | "Attacking: three review rounds … 14 defects …; a line-by-line read by Claude found 4 more; two further Claude referees … found 23 smaller ones. No counterexample in any round; all repaired. … 1067 leaf counts up to 400 leaves and primes up to 13, no failures." | §9.2, "Main proof"; §6, rows E000, E003 | Yes (23 = 10 + 13; in the report "smaller" is said of the 13). |
| 26 | "Machine-checked (Lean 4, Mathlib): the whole theorem, valuation and residue, for every q = p^k; for q = 2: v_2(C_n) = s_2(n + 1) − 1." | §7.1, §7.2 | True and out of date. → B-M14 |
| 26 | "What humans verified: to be filled in." | §2.3; §9.4 | **A placeholder.** → B-M5 |
| 27 (uncommitted) | Diagram: humans (direction, budget) → Claude orchestrator (ideas, briefs) → a claim → heavy computer checks → written proof → 3+ models → Claude checks again → Lean 4 and human → "= theorem"; the grades conjecture, computed, AI-proved, AI-reviewed, human-signed | §9.2, search "diagram on the slides" | The diagram is in the report in words. |
| 27 | "**3+ models** check every claim, each says CORRECT / GAP / WRONG"; title "every claim runs the gauntlet" | §9.2, the list after "Concretely"; `CLAIMS.md` | **More than the record.** Three models read the first round of the main proof. The accounting proof, the algebraic proof and the carry budget had one AI referee each (the same model as the author); the lattice-path proof two AI readers; C9, C17, C21 none. → B-M7 |
| 27 | "Lean 4: machine-checked + 2 Claude auditors" and "Human reads and signs", each with an arrow to "= theorem", "in either order" | §7.1; §9.2; the project's rule that only human-signed claims are presented as theorems | **Ambiguous:** it can be read as "a Lean check alone makes a theorem". Two audits cover the statements of the main proof and a third (`lean/AUDIT3.md`, 15 November) those of the algebraic and lattice-path proofs and of four extension files; the file on weights is not audited, and the accounting proof is not formalized. → B-M7 |
| 27 | "everything the sub-agents output is checked again by Claude" | §9.2, "Lean files written by delegated models"; §6, "run by a worker model; not rerun" | **Overstated:** some computations of workers were read and not rerun (the sand simulation; `AI_USAGE.md`: E002 and E005 "not re-run independently"). → B-M7 |
| 27 | "Everything is recorded. … the journal and state file let an agent that stopped running … pick up with full context." | §9, first paragraph, has the journal, the ledger and the log; **the state file and the resumption are not in the report** | True of the repository. → B-R11 |
| 27 | "Every worker run is logged automatically." | §9, first paragraph, "automatic log" | Yes for the Open Math OS workers (the log ends with run W040; the later Claude sessions are recorded by their briefs and the journal). |
| 27 | "Every file and statement is marked: verified by a human or not, and if an AI made it, which specific AI." | §2.3 does this for claims; the report says nothing of the kind about files | **Overstated:** in a crude search, 27 of 360 tracked text files name no model, AI or human in their first 15 lines. → B-M7 |
| 27 | Source comment: "Written by Claude Opus 5.5 (Claude Code)" | §9.1, row "Claude Opus 5.5 in Claude Code" ("according to a comment in the source of the slides") | To be confirmed by a person. |
| 28 | Etherington; Deutsch and Sagan; Postnikov and Sagan; Konvalinka; Kersting and Fischer ("No mention of Catalan numbers."); Kauers, Krattenthaler and Müller; Krattenthaler and Müller; "Sequences: OEIS A000625, A001190" | Bibliography; §1.2; §1.4; §5, last paragraph | Yes; every field agrees with the report's bibliography. |
| 28 | "Counting trees up to a group at each node: G. Pólya, Acta Math. (1937)." | **Not in the report and not in `references/README.md`.** The report cites Pólya 1936 (Zeitschrift für Kristallographie 93, 415–443), for two equations, read by an AI from a scan | **Contradicts the project's rule on citations.** → B-M1 |
| 28 | "Ours, as far as we could check: the p-group action for q = p^k, the digit skeleton with its depth condition, the carry–cherry count, the residue for all prime powers. Not a certificate of novelty." | §1.4 | **"The residue for all prime powers" contradicts §1.4** ("Not claimed: … the residue formula as a statement"). The first two items need the report's qualifications. → B-M2 |
| 29 (backup) | Figure: 13 single leaves; 6, 3 and 1 fusions; "10 carries in all = (13 − 3)/(2 − 1)"; the text "12 nodes, at most 10 of them symmetric (one per carry), so at least 2 asymmetric" | §5 item 6, "after $10$ fusions"; §4.4 | Yes. |
| 29 | "The same bookkeeping: a binary counter, a binomial heap, a buddy memory allocator, sand that topples in pairs." | Binomial queues: §5 item 6; sand: §5 item 11. **Binary counter and buddy allocator: not in the report.** | → B-R12 |
| 29 | "In the proof, each fusion is a cherry of p equal subtrees collapsing." | Appendix C, last paragraph, "a toppling on the line is a cherry of the digit forest being contracted" | **True of the accounting proof only.** In the main proof the cherries that collapse are p distinct labels, t times; the 10 fusions are the symmetric nodes inside the atoms. → B-M11 |
| 30 (backup) | Figure: a binary tree with 5 leaves, the code words 00, 01, 10, 110, 111, pieces 1/4, 1/4, 1/4, 1/8, 1/8, five balls | §5 item 8 has the general statement; **the example is not in the report** | Correct. → B-R13 |
| 30 | "The Catalan number C_(m−1) counts the ways to cut the 2-adic integers into m balls"; "prefix codes and blocks of addresses; for q = 2^8 the blocks are aligned to whole bytes" | §5 item 8 | Yes. |
| 30 | "our rotations are isometries of them" | **Not in the report** | True (elementary). → B-R13 |
| 31 (backup) | Figure: 39 ends; "grown at random: 19 junctions: 9 symmetric, 10 asymmetric"; "the most symmetric one: 18 symmetric, 1 asymmetric; three perfect branches with 27, 9 and 3 ends: 39 = 1110_3" | **Not in the report** (only the general sentence of §5 item 9) | Correct (39 = 1110 in base 3, 19 junctions, t = 1; the figure script asserts d = 1). → B-R14 |
| 31 | "A molecule with m ends can be perfectly branched only if m is a power of p; otherwise it is t junctions short."; Stockmayer's factor | §5 item 9 | Yes. |
| 32 (backup) | Figure: "3 pictures: two of the three parts cut"; "12 = 3 + 9"; "9 pictures: a part cut, and a part of it cut again"; "4 inner points, all three parts cut: alone in its family; 55 = 1 + 9 + 9 + 9 + 27"; "the twin of tert-butyl" | §5 item 9, "$12=3+9$"; §2.2, "An odd prime". **The descriptions of the families and the triangle with 4 inner points are not in the report.** | Correct (recomputed). → B-R15 |
| 33 (backup) | Figure: recipes "4 + 1" (one mixing step) and "3 + 2" (two); 1064, 532, 355, 266, 213 nm; "5 = 101_2: two ones, so one mixing step cannot be avoided" | The bound: §5 item 10. **The recipes and the wavelengths are not in the report.** | The bound: recomputed for m ≤ 16. → B-R16 |
| 33 | "Both recipes for the fifth harmonic are in use." | **Not in the report.** `references/README.md`, entry 27: an abstract (4 + 1) and a trade-magazine article (3 + 2) | A statement about practice in another field without a source in the report. → B-R16 |
| 33 | "(A real apparatus can reuse a beam; then the count can drop, first at m = 15.)" | §5 item 10, "first at $m=15$" | Yes (recomputed for m ≤ 20). |
| 34 (backup) | Figure: 7 grains, rule "2 grains become 1 on the next site": on a line 4 topplings, "what is left is 7 = 111_2"; on a ring of 2 sites 6 topplings; "6 − 4 = 2 = power of 2 in the number of 4-ary trees with 7 leaves (there are 4 of them)" | The proposition: Appendix C, "On the half-line of sites"; §5 item 11. **The example is not in the report.** | Correct (simulated). → B-R17 |

### Must change before presenting (15)

- **B-M1 [high]. Page 28, "G. Pólya, Acta Math. (1937)".** Not in the reference list, so it may not be cited (rule 4 of `CLAUDE.md`). Smallest fix: replace the line by "The equation for A000625: G. Pólya, Z. Kristallogr. 93 (1936) 415–443 (read by an AI from a scan)", which is the report's entry, or delete the line and keep "Sequences: OEIS A000625, A001190".
- **B-M2 [high]. Page 28, "Ours".** Suggested text: "Ours, as far as we could check: the use of rotations (a p-group) for this theorem, for q = p^k; the smallest classes in base p with the depth condition (their shape is Konvalinka's); their count mod p by collapsing cherries, and with it exactness and the residue from tree symmetries. The residue formula itself is classical." Add to the list above it: "the residue as a statement: a classical congruence for binomial coefficients (Anton, Stickelberger, Hensel)".
- **B-M3 [high]. Page 6, the butyl figure.** In `talk/figures/make_figures.py`, function `fig_butyl`: the legend entries "symmetric carbon" and "asymmetric carbon" and the label "… asymmetric" under each molecule; write "lopsided carbon" (and for instance "balanced carbon"), run the script, recompile. Without regenerating: say aloud that "asymmetric" is the talk's word and not the chemists' (they mean a carbon with four different groups).
- **B-M4 [high]. Page 22.** C10 and C11 are proved in the report (§4.5) and checked by Lean; only C9 is a conjecture. Smallest fix: header "one conjecture, two small theorems"; "(conjecture C10)" → "(proved in the report, §4.5; checked by Lean; not claimed as new)"; "(conjecture C11)" → "(proved in the report, §4.5; checked by Lean)"; "should divide" → "divides"; last line "Weighted numbers: computed for six values of q, not proved. The two proofs were written on the last night and no human has read them."
- **B-M5 [high]. Page 26, "What humans verified: to be filled in."** From §2.3 and §9.4: "A faculty member of the team looked through the main proof and approved it; read and verified the lattice-path proof; read the accounting proof (not signed). No human has checked the algebraic proof, the Lean files or the sources on other fields."
- **B-M6 [high]. Page 26, "Writing".** From §9.1 and the log of runs: "Writing: the first LaTeX write-up of the main proof, a replication of the checks, the literature scan and a first draft of slides by Kimi K3.1 Pro (Open Math OS); the three further proofs, the figures and most of these slides, most of the Lean files by Claude Fable 5.2; one slide by Claude Opus 5.5. Reviews by Mistral Large 4.0, Muse Spark Open, Kimi K3.1 Pro and separate Claude sessions." DeepSeek Flash did a connectivity test only.
- **B-M7 [high]. Page 27 (uncommitted).** Three statements go beyond the record and one can be misread; smallest fixes: "3+ models check every claim" → "3 models read the main proof; 1 or 2 independent AI readers for the others", and the title "every claim runs the gauntlet" → "the path of a claim"; "everything the sub-agents output is checked again by Claude" → "read by Claude; Lean files recompiled"; "Every file and statement is marked" → "Every claim in the ledger says who produced it and whether a human signed it"; for "= theorem", draw one arrow from "Lean 4" through "Human reads and signs" to "= theorem", or write "Lean: evidence" and "human-signed = theorem". The slide must also be committed, and a person should confirm which tool wrote it (the report says "according to a comment").
- **B-M8 [medium; a human decision]. The two switches at the top of `talk/slides.tex`** (`\claimstatus`, `\ourresult`): "candidate proof, under verification" on nine pages and "Claim" in four blocks, against the report's "Theorem 3.1 … approved by a faculty member … Lean". If "Claim" becomes "Theorem", note that page 15 (carry budget) carries the same footer and has no human reader.
- **B-M9 [medium]. Page 24.** Header → "algebra: checked by Lean and one AI referee, read by no human; accounting: read by a faculty member, not signed". Consider one line for the lattice-path proof (Appendix A), the proof that a human read and verified; then the title is "Three more proofs".
- **B-M10 [low]. Page 18, "together 132 = 4·33".** → "The three classes hold 12 of the 132 trees; 132/4 = 33 is odd."
- **B-M11 [low]. Page 29 (backup), last sentence.** → "Each fusion is a symmetric node inside a complete tree; in the accounting proof it is a cherry of the digit forest being contracted."
- **B-M12 [low]. Page 11, "The answer can only depend on m."** Drop it, or "The answer will turn out to depend only on p and m."
- **B-M13 [low]. Page 23, "For p = 2 this is literal".** → "For p = 2 the arithmetic is that of".
- **B-M14 [low]. Page 26, the Lean line.** Up to date it reads: "three proofs, valuation and residue, for every q = p^k, stated with Mathlib's own binomial coefficient; builds on Lean v4.35.0 with no `sorry`; no human has read the Lean files". And "23 smaller ones" → "10, then 13 smaller ones".
- **B-M15 [low]. Pages 15, 17, 31, "the most symmetric tree".** There are three with 7 leaves, three with 13 leaves and two with 39 ends: "a most symmetric tree". §5 item 6 of the report has the same wording.

### Add to the report or drop from the slide (17)

- **B-R1. Page 3, the two bar charts.** L-B1.
- **B-R2. Page 5, the four drawings** (species, players, code words, notes). L-B2.
- **B-R3. Page 9, "classes of 1, 4, 6, 12 or 24".** L-B3.
- **B-R4. Page 10, the three families of cut squares.** L-B4.
- **B-R5. Page 15, the two trees with 7 leaves.** L-B5.
- **B-R6. Page 17, C_12 = 208012.** L-B6.
- **B-R7. Page 18, "the rooted phylogenetic trees on the three 1-bits of 7".** L-B7.
- **B-R8. Page 19, "T(3) ≡ −T(2) ≡ T(1) = 1, and indeed T(3) = 3".** L-B8.
- **B-R9. Page 25, "Exactness — not just divisibility — comes free."** Drop, or "Exactness comes from counting the smallest orbits modulo p."
- **B-R10. Page 26, "explainer".** Drop the word, or L-B10.
- **B-R11. Page 27, the state file.** L-B11.
- **B-R12. Page 29, "a binary counter, … a buddy memory allocator"** (in the figure). L-B12, or regenerate the figure without the two.
- **B-R13. Page 30, the example with 5 leaves and "our rotations are isometries".** L-B13.
- **B-R14. Page 31, the example with 39 ends.** L-B14.
- **B-R15. Page 32, the families of triangles and "the twin of tert-butyl".** L-B15.
- **B-R16. Page 33, the recipes, the wavelengths, "both recipes … are in use".** L-B16 (a human decision: the sources are an abstract and a trade magazine), or drop the sentence and keep the figure as an example.
- **B-R17. Page 34, the example with 7 grains.** L-B17.

Cutting the six backup slides removes B-M11 and B-R12 to B-R17.

---

## What the report has and neither deck mentions

One sentence each, for the speaker.

1. **Three proofs checked by Lean on the required versions** (§7.1, §7.2). "Three proofs of the theorem are formalized in Lean 4; the project builds on Lean v4.35.0 with Mathlib v4.35.0, without `sorry`, and the final statement uses only Mathlib's binomial coefficient, digits and multiplicity; no human has read the Lean files." (Deck B has Lean for one proof; deck A has nothing.)
2. **The lattice-path proof** (§4.1, Appendix A). "A second proof by a group action, on lattice paths, proves Kummer's theorem with its residue; a faculty member read and verified it; its method is known (Smith, Wildon), and it acts on paths, not on trees." (On neither deck.)
3. **Level profiles and invariant weights** (§4.5). "For any numbers n_i of nodes on each level, p^t divides ∏ binom(q·n_i, n_(i+1)); and the sum of any weight that rotations do not change is divisible by p^t. Both are a few lines from Steps 1 and 2 and are checked by Lean; no human has read the proofs, and we do not claim that they are new." (Deck B shows the first as a conjecture.)
4. **The audit of the formal proofs** (§7.3, search "Until 03:00 on 15 November the Lean file used"; §7.5, "the list is empty for every final theorem"). "An independent audit found that the Lean version of the algebraic proof used, deep inside the library, Kummer's theorem and Legendre's formula; the file was rewritten, and a search by names through everything the three proofs use now finds no valuation of a factorial or of a binomial coefficient. It is a search by names."
5. **What is classical about the residue** (§1.2, §1.4). "The residue formula is, as a statement, a consequence of a classical congruence for binomial coefficients; what is ours is its derivation from the symmetries of the trees."
6. **The exact number of smallest classes for q = p** (Corollary 3.27): (pt)!/(t!·p^t·∏ m_j!); for p = 2 it is the known (2s − 3)!!.
7. **Who has read what** (§2.3): main proof approved by a faculty member; lattice-path proof read and verified; accounting proof read, not signed; algebraic proof and Lean files read by no human.

## Notes on the report, found while checking

1. **§9.2, the clause "three or more models read it and mark every step correct, gap or wrong"** (search "three or more models read") repeats the workflow slide and is contradicted by the list that follows it. Suggested replacement of that clause: `for the main proof three models read it in the first round and marked every step correct, gap or wrong (the other proofs had one or two AI readers each, as listed below)`.
2. **§5 item 6, "The most symmetric tree with $13$ leaves"** (search "The most symmetric tree with $13$"): there are three; "A most symmetric tree with $13$ leaves (there are three)".
3. **Sentences that speak of "the slides"** fit only one deck. They describe deck B: §5, "the connections that the team's slides show" and "(four pictures of one slide of the talk)"; §6, "the numbers shown in the pictures of the slides"; §9.1, the row of Claude Opus 5.5; §9.2, "the diagram on the slides". They describe deck A: §2.2, "is on the team's slides", and the row "A converse (on the slides" of the status table. After the choice, the others should say "a deck that was prepared and not presented".
4. **§5 item 10, "it is Step~2"**: the bound for mixing steps counts nodes whose two subtrees have different numbers of leaves, which is fewer nodes than the asymmetric ones; it follows from the induction of Step 2, which uses only the numbers of leaves, and not from its statement. Suggested: `by the induction of Step~2, which uses only the numbers of leaves`.
5. **§9, "an automatic log of every run of a delegated model"**: the automatic log covers the Open Math OS runs (it ends with W040); the Claude sessions W041 to W054 are recorded by their briefs and by the journal.
6. **Who made deck A, and with which tool,** is not in the report (§9.4 says "Team members prepared the talk"). If an AI tool was used, §9.1 should name it: a question for the humans.
7. **§7.1, "the files added after those audits … are covered only by the Lean kernel and by the reading of the AI system that coordinated the work"** is older than the third audit (`lean/AUDIT3.md`, 15 November, which the report cites in §7.3 and §7.5): that audit covers the algebraic and lattice-path proofs, the exact count, the carry budget, the closed families and the level profiles, and looked more lightly at five further files. The sentence understates; it should name the third audit and what it left out (the file on weights). Likewise §9.1 (the row of the further sessions) says "Two audits of the Lean statements"; there are three.

---

## Sentences ready to paste into `report/report.tex`

Each is true and supported by the repository or by the computations listed at the top, unless marked. All were written by an AI system on 15 November and read by no human; a sentence added inside Section 3 or the appendices (approved or reviewed texts) should be marked as added, so they are placed in Sections 1, 2, 4, 5 and 9 instead.

**P1 (deck A, A-M1). The converse of slide 12. A human decision:** paste this, or change the slide to "if". Place: §2.2, last paragraph, replacing the sentence that begins "The converse, that no such tree exists".

```latex
The converse also holds: \emph{if a tree counted by $T(\mathbf a)$ exists, then $\mathbf a\ne0$ and
$\sum_ca_cp^c\equiv1\pmod{q-1}$.} It is not needed for any proof. \emph{Proof.} In a $p$-ary tree the depths
$\ell$ of the leaves satisfy $\sum_{\text{leaves}}p^{-\ell}=1$: this holds for a single leaf, and replacing a
leaf at depth $\ell$ by a node with $p$ leaves at depth $\ell+1$ does not change the sum. Let $D$ be a multiple
of $k$ that is at least the depth of every leaf; then $\sum_{\text{leaves}}p^{D-\ell}=p^{D}$, a sum of
integers. Since $p^k=q\equiv1\pmod{q-1}$, we have $p^{D}\equiv1$, and $p^{D-\ell}\equiv p^{c}\pmod{q-1}$ for a
leaf of depth class $c\in\{0,\dots,k-1\}$, because $D-\ell\ge0$ and $D-\ell\equiv c\pmod k$. Hence
$\sum_ca_cp^c\equiv1\pmod{q-1}$, and $\mathbf a\ne0$ because a tree has a leaf. \qed\ (This proof was written by
AI systems on 15 November and has been read by no human. The equivalence was checked by computer for
$(p,k)=(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(5,1),(5,2)$ and every label vector with at most $7$ to $10$
labels, $1041$ vectors; the program is not kept in the repository. In the algebraic proof the corresponding
statement is Remark~\ref{frob:rem:support}.)
```

With P1, the row "A converse (on the slides; no number in the ledger)" of the status table becomes:

```latex
 & \emph{Proved in this report:} Section~\ref{sec:smallexamples}, last paragraph (three lines, written on
 15 November). \emph{Computation:} $1041$ label vectors for nine pairs $(p,k)$. Not needed for any proof; not
 in Lean.
 & No.\\
```

**L-A1 (deck A, A-R1).** Place: §2.1, after the paragraph "In one sentence".

```latex
On the slides the set of equivalence classes of cyclic skeleton trees for $m$
(Definition~\ref{main:def:skeleton}) is written $\mathcal S(m,k)$, so that $N_{\min}=|\mathcal S(m,k)|$
(Proposition~\ref{main:prop:skeleton}), and $\mathcal T(\mathbf a)$ is the set of labelled cyclic trees whose
number is $T(\mathbf a)$ in Section~\ref{main:sec:count}, so that $|\mathcal T(\mathbf a)|=T(\mathbf a)$.
```

**L-A2 (deck A, A-R2).** Place: §2.1, after the list of steps. Only if deck A is presented.

```latex
The slides number the same steps from $1$ to $7$: their Step~1 is Step~0 here; their Step~2 is Step~1; their
Steps~3 and~4 are Step~2 and the criterion for equality (Proposition~\ref{main:prop:minimal-local}); their
Step~5 is Step~3; their Step~6 is the first sentence of Step~4 (Proposition~\ref{main:prop:free}); their
Step~7 is the rest of Step~4 (Propositions~\ref{main:prop:carry} and~\ref{main:prop:carry-termination}).
```

**L-A3 (deck A, A-R3).** Place: §2.2, a new paragraph before "Values of the theorem".

```latex
\emph{A minimal ternary tree.} For $p=q=3$, $n=8$: $m=17=122_3$, $t=2$, and the atoms have $9,3,3,1,1$ leaves.
The first skeleton pictured in Example~\ref{main:ex:ternary}, $((K_0,K_0',K_1),K_1',K_2)$, expands to a tree
whose root has subtrees with $5$, $3$ and $9$ leaves, and $5+3+9=012_3+010_3+100_3=122_3$ is added without a
carry; the node below the root adds $1+1+3=001_3+001_3+010_3=012_3$, again without a carry. Both nodes are
asymmetric, and $d=t=2$.
```

**L-A4 (deck A, A-R4, optional).** Place: §2.2, at the end of "A prime power".

```latex
For example, the $4$-ary tree whose root has an internal node as first and as fourth child, each with four
leaves, and a leaf as second and as third child becomes $((K_2,\bullet),(\bullet,K_2))$ with
$K_2=((\bullet,\bullet),(\bullet,\bullet))$: two leaves at depth $2$ and eight at depth $4$. Its root is
symmetric, the two nodes below the root are asymmetric, and its class is the one of size $4$.
```

**L-A5 (deck A, A-R5, optional).** Place: §2.2, "Labelled skeletons and carries", after "(Example~\ref{main:ex:ternary})."

```latex
With labels $x_1,x_2,x_3,y_1,y_2$ and the $3$-cycle $(x_1\,x_2\,x_3)$, one orbit of size $3$ is
\[
 (x_1,x_2,(x_3,y_1,y_2)),\quad(x_2,x_3,(x_1,y_1,y_2)),\quad(x_3,x_1,(x_2,y_1,y_2)),
\]
and the four fixed trees are
\[
 (y_1,y_2,(x_1,x_2,x_3)),\quad(y_1,y_2,(x_1,x_3,x_2)),\quad(y_1,(x_1,x_2,x_3),y_2),\quad(y_1,(x_1,x_3,x_2),y_2),
\]
the children of a node being taken up to cyclic rotation; collapsing the cherry to one leaf $z$ gives the two
trees $(y_1,y_2,z)$ and $(y_1,z,y_2)$ counted by $T(3)=2$.
```

**L-B1 (deck B, B-R1).** Place: §1.1, before "The general statement is:".

```latex
(One slide shows the same pattern as two bar charts: $v_2(C_n)$ for $1\le n\le64$, which is $0$ exactly at
$n=1,3,7,15,31,63$ and largest, $5$, at $n=62$; and $v_3$ of the number $\binom{3n}{n}/(2n+1)$ of ternary
trees with $n$ nodes for $1\le n\le41$, which is $0$ exactly at $n=1,4,13,40$ and at most $3$.)
```

**L-B2 (deck B, B-R2).** Place: §5 item 1, at its end, after "and one is enough."

```latex
The tree is $((\bullet,\bullet),((\bullet,\bullet),(\bullet,\bullet)))$; the four pictures show it as the
evolutionary tree of six species, as a knockout tournament of six players, as the prefix code with the words
$00,01,100,101,110,111$, and as a bar of music with two quarter notes and four eighth notes.
```

**L-B3 (deck B, B-R3).** Place: §5 item 5, before "The picture is special to $q=4$".

```latex
More exactly, a row of four subtrees, some of them equal, has $1$, $4$, $6$, $12$ or $24$ rearrangements
under all permutations (the multinomial coefficients) and $1$, $2$, $4$ or $8$ under the eight.
```

**L-B4 (deck B, B-R4).** Place: §5 item 5, after "with three cuts, $22=2+4+16$".

```latex
(the family of $2$: two opposite quarters cut; the family of $4$: two neighbouring quarters cut; the family
of $16$: one quarter cut, and one quarter of it cut again; such a picture has $10$ cells, $10=1010_2$, so
$t=1$ and $22=2\cdot11$)
```

**L-B5 (deck B, B-R5).** Place: §4.4, at the end of Consequence (1), after "at least $2$ are asymmetric."

```latex
With $7=111_2$ leaves, $\nu(7)=4$: the tree $(K_2,(K_1,K_0))$ makes its four carries at its four symmetric
nodes and none at its two asymmetric nodes, so $d=2=t$; the tree
$((((((\bullet,\bullet),\bullet),\bullet),\bullet),\bullet),\bullet)$ makes one carry at its only symmetric
node and three at asymmetric nodes ($3+1=100_2$ costs two, $5+1=110_2$ costs one), so $d=5=t+3$.
```

**L-B6 (deck B, B-R6).** Place: §5 item 6, after the sentence that ends "building blocks."

```latex
(Here $t=2$, the power of $2$ in $C_{12}=208012=2^2\cdot52003$.)
```

**L-B7 (deck B, B-R7).** Place: §5 item 1, at its end (after L-B2 if both are used).

```latex
For $p=2$ the atoms of a minimal tree have distinct heights, so by Proposition~\ref{main:prop:free} the minimal
classes are the binary trees, up to exchanging branches, whose $s_2(m)$ leaves carry distinct labels, one for
each binary digit $1$ of $m$: in the language of this field, the rooted binary phylogenetic trees on $s_2(m)$
species. There are $(2s_2(m)-3)!!$ of them (Corollary~\ref{main:cor:exact-count} for $p=2$); for $m=7$ these
are the three trees of Example~\ref{main:ex:binary}.
```

**L-B8 (deck B, B-R8).** Place: §2.2, "Labelled skeletons and carries", after "(Example~\ref{main:ex:ternary})."

```latex
For $p=2$, $k=1$: $T(1)=1$, $T(2)=1$, $T(3)=3$, and $T(3)\equiv-T(2)\equiv T(1)=1\pmod2$; this is the example
with $7$ leaves, where $N_{\min}=T(3)=3$ (Example~\ref{main:ex:binary}).
```

**L-B10 (deck B, B-R10).** Place: §9.1, the row of Kimi K3.1 Pro, after "first draft of slides;". (The header of `explainer/index.html` names Kimi K3.1 Pro, worker W005.)

```latex
an interactive explainer page, which is not used in this report;
```

**L-B11 (deck B, B-R11).** Place: §9, first paragraph, after "with its brief and its output."

```latex
A file with the current state and the list of next actions is kept beside the journal, so that a session
that stops can be continued by another one from the record alone.
```

**L-B12 (deck B, B-R12). A human decision:** the second sentence cites a paper of which only the bibliographic record was seen (`references/README.md`, entry 22); the first sentence alone needs no source. Place: §5 item 6, after "each fusion is a carry (Section~\ref{sec:carrybudget})."

```latex
\textbf{[analogy]} The same bookkeeping, equal blocks fusing in pairs, is that of a binary counter and of
the buddy system of memory allocation \cite{Knowlton}.
```
```latex
\bibitem{Knowlton}
Kenneth C. Knowlton, ``A fast storage allocator'', \emph{Communications of the ACM} \textbf{8} (10) (1965),
623--624. DOI: \href{https://doi.org/10.1145/365628.365655}{10.1145/365628.365655}. [Bibliographic record
only; the behaviour of the buddy system was read by an AI in secondary sources.]
```

**L-B13 (deck B, B-R13).** The second sentence is elementary and was checked by hand only. Place: §5 item 8, after "and for $p$-ary trees $2$ is replaced by $p$."

```latex
For example the tree $((\bullet,\bullet),(\bullet,(\bullet,\bullet)))$ with $5$ leaves is the prefix code
$00,01,10,110,111$, the cut of an interval into pieces of lengths $\tfrac14,\tfrac14,\tfrac14,\tfrac18,
\tfrac18$, and a cut of the $2$-adic integers into five balls. Exchanging the two halves of a ball changes
one binary digit of each of its points and is an isometry of the $2$-adic integers, so the rotations of the
proof act on these cuts by isometries.
```

**L-B14 (deck B, B-R14).** Place: §5 item 9, after "junctions short."

```latex
For example with $p=3$ and $m=39=1110_3$ ends there are $19$ junctions and $t=1$: a most symmetric molecule
joins perfect branches with $27$, $9$ and $3$ ends at one lopsided junction, the other $18$ junctions being
symmetric; a tree grown at random, drawn beside it on the slide, has $10$ lopsided junctions.
```

**L-B15 (deck B, B-R15).** Place: §5 item 9, at its end, between "$12=3+9$" and the full stop.

```latex
(the family of $3$: two of the three parts cut; the family of $9$: one part cut, and one part of it cut
again). With four inner points, $55=1+9+9+9+27$, and the picture that is alone in its family, the triangle
with all three parts cut, is the complete tree of height $2$, the tree of \emph{tert}-butyl in item~3
```

**L-B16 (deck B, B-R16). A human decision:** the first source was read as an abstract only, the second is a trade magazine for which the reference list has no full record; "are in use" on the slide should become "are described", or the sentence should go. Place: §5 item 10, after "(all shapes up to $m=20$; it is Step~2)."

```latex
For example the fifth harmonic of a laser at $1064$~nm, at $213$~nm ($5=101_2$), needs one mixing step when
it is made as $4+1$ (doubling twice, to $532$ and $266$~nm, then mixing with the pump) and two when it is
made as $3+2$ (through $355$~nm). \textbf{[known, from an abstract]} The recipe $4+1$ is that of \cite{Yap};
the recipe $3+2$ is recorded in the project's reference list from a trade-magazine article only.
```
```latex
\bibitem{Yap}
Y. K. Yap, M. Inagaki, S. Nakajima, Y. Mori and T. Sasaki, ``High-power fourth- and fifth-harmonic generation
of a Nd:YAG laser by means of a CsLiB6O10'', \emph{Optics Letters} \textbf{21} (17) (1996), 1348. DOI:
\href{https://doi.org/10.1364/ol.21.001348}{10.1364/ol.21.001348}. [Abstract only, read by an AI: 213~nm by
mixing the 266~nm and 1064~nm beams.]
```

**L-B17 (deck B, B-R17).** Place: §5 item 11, at the end.

```latex
For example $p=2$, $k=2$, $m=7$: on a line the seven grains topple $4$ times and leave $7=111_2$; on a ring
of two sites they topple $6$ times and leave one grain; $6-4=2$, and the number of $4$-ary trees with $7$
leaves is $C_2^{(4)}=4=2^2$.
```

(L-B9 does not exist: B-R9 is rhetoric and should be dropped from the slide.)

---

## What I did not verify

- **The report's proofs and the Lean project.** Not read for correctness and not built; this file compares statements.
- **Sources.** I opened no paper. Whether a slide agrees with a source is judged through the report and `references/README.md` only. The bibliographic fields in L-B12 and L-B16 are copied from entries 22 and 27 of that list.
- **Numbers taken from the ledger** and not recomputed: 1067 leaf counts; 14, 4, 10 and 13 defects; the ranges of the level profiles and of the weighted numbers; the count of 43 candidate connections.
- **The figures** were read as page images at screen resolution and through their text layer; I did not rerun `talk/figures/make_figures.py`. The random tree of the polymer figure (9 symmetric, 10 asymmetric junctions) was not recomputed; the script computes its caption from the tree it draws.
- **P1** is a proof written by AI sessions (the reviewer of brief W053 wrote the same argument) and read by no human; my computation covers small cases only.
- **The count "27 of 360 files"** is a text search for the words Claude, Kimi, Mistral, Muse, DeepSeek, Opus, Fable, worker, human or AI in the first 15 lines of each tracked text file outside `logs/`; it is an indication, not an audit.
- **The speaker notes** `talk/NOTES.md` and the answers in `talk/QA.md` were not compared with the report.
