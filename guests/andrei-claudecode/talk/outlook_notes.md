# The outlook: two slides

Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code, started by Andrei, 2026-11-15 at 07:35 PT. Not human-reviewed.
This replaces the notes on the four-row slide "What comes next" of 14 November, which these two slides replace.

**Asked by Andrei:** "for outlook slides I want just the attached and weighted Fuss–Catalan. Make the info on the attached slide more concise and expand on Fuss–Catalan." The attached file was `from_numbers_to_polynomials_slide.pdf`, one slide in the look of the teammate's deck, numbered 16.

**Who wrote what.** Slide 16 here is a shorter version of that slide: its formula, its example, its numbers and its last sentence are taken from it. I do not know who or which tool wrote the original. Slide 17 is AI-written, from the team's record. The layout of both is AI-written.

Files: `outlook_slide.tex` and `outlook_slide.pdf` (two pages, numbered 16 and 17; the first number is one line at the top of the source), `check_outlook.py` with `check_outlook_output.txt` (10 checks, all pass), `outlook_trees.tex` (written by the script), `deck_style.tex`.

## Slide 16, "From numbers to polynomials"

**What was cut from the original.** The sentence "T runs over the q-ary trees with n internal nodes" (say it); "by hand" and "by computer"; "12 monomials". Kept: the definition of P_n, the consequence, the example with its two pictures, the value for n = 6 in small type, and the box at the bottom, with its two sentences unchanged apart from a comma.

**What to say.** "Instead of counting the trees, record two things about each: its height, and the sum of the depths of its leaves. A rotation changes neither. So the whole proof applies to every coefficient of this polynomial: each is divisible by p^t, and modulo p^(t+1) only the smallest classes are left. For ternary trees with three internal nodes there are two shapes, three trees and nine trees, and modulo 9 only the first survives."

**Checked** (`check_outlook.py`, 1a to 1g): the two classes of 3 and 9 trees with x²y¹³ and x³y¹⁵; P_3; for n = 6 the 1428 trees and P_6 ≡ 6x³y³⁴ (mod 9), and also the "12 monomials" of the original; that both statistics are constant on rotation classes, that p^t divides every coefficient and that modulo p^(t+1) only the classes with d = t remain, for p = q = 2 (n ≤ 11), 3 (n ≤ 7), 5 (n ≤ 4); divisibility for q = 4, 8, 9 in small cases.

**Against the report** (the rules: everything on the slides must be in the report). The general statement is there: Section 4.5, "Closed families" (C11) and "Weights that rotations do not change" (C28), both proved and checked by Lean in the night. **Not there:** the polynomial P_n itself, the example P_3, the value of P_6, and **the sentence about Gaussian binomials and cyclotomic factors** (the words "Gaussian" and "cyclotomic" do not occur in the report at bdc310c). Either the report gets these, or the slide loses them. I did not check the Gaussian sentence against any source; it is the original slide's.

**Is it future work?** Not quite: divisibility of the coefficients follows from statements proved in the night. What is open is the last box.

## Slide 17, "Weighted Fuss–Catalan numbers"

**What to say.**
- "Konvalinka gives every node a weight. Walk from the root to the node and count the steps that do not go to the rightmost child: that is the index of the node, and its weight is b of that index. In the picture the indices are 0, 1, 0, 1. The weighted number is the sum over all trees of the product of the weights."
- "His theorem: if the weights satisfy two congruence conditions, the weighted number agrees with the plain one modulo a higher power of p."
- "A rotation moves the rightmost branch, so it changes these weights. This is exactly a statistic that rotations change. Still, his proof seems to need only that the group can move every branch to every position, and our rotations can. If so, his theorem also needs no factorial valuations. That is a conjecture; it holds in every case we computed."

**Where each part is in the record.**
- Definition and theorem: `report/report.tex`, Section 4.5, item "Weighted Fuss–Catalan numbers (C9), a conjecture", which takes them from the project's reading notes of his paper (`references/README.md`, "Weighted numbers", "Theorem 5") "and says no more than they do". Δ is the difference operator; the report notes that the reading notes do not define it.
- The conjecture: the same item, in the words of the ledger: his proof works unchanged with the rotation group in place of the full symmetric group, because it only needs the group to be transitive on the q branches of a node. "It has not been written out as a proof." Also in the report's "Next steps".
- "Every case computed": the team's `experiments/E002_extensions` (q = 2, 3, 4, 5, 8, 9, four weight functions each, with the orbits of the rotation group). I did not rerun it.
- "Rotations change this weight": the report says so in the same item.

**Checked here** (2a to 2c): the indices of the tree in the picture; that all weights 1 give the number of trees; and **the theorem itself**, not the conjecture, for the weight b(i) = 1 + q²·i, which meets his conditions (48 cases, q = 2, 3, 4, 5, 8, 9), with a control weight b(i) = 1 + i that does not meet them and fails in 36 of the 48. This confirms that the definition on the slide is read the way his theorem needs. It says nothing about his proof.

**Do not mix up** with what was proved in the night: a weight that rotations do not change, summed over the trees, is divisible by p^t (C28). The report says in so many words that this is not Konvalinka's weighted theorem. Slide 16 is a case of C28; slide 17 is not.

## Not checked

- Konvalinka's paper was not read in this session.
- The sentence about Gaussian binomials.
- No person has read these two slides.

## Build

```
python3 check_outlook.py > check_outlook_output.txt
latexmk -pdf outlook_slide.tex
```
