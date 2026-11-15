# The slide "What comes next"

Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code, started by Andrei, 2026-11-14 at about 22:10 PT. Not human-reviewed.
Asked by Andrei: "make a slide for what we plan to do in the future". The choice of the four rows and their wording are AI-written; every row comes from the team's own record, named below.

Files: `outlook_slide.tex` and `outlook_slide.pdf` (one page, 16:9), `check_outlook.py` with `check_outlook_output.txt` (5 checks, all pass), `deck_style.tex` (the look, shared with `intro_slides.tex`).

## Where the slide goes

Before the last slide of the team's deck ("In one sentence … Questions?"), after "What is known, and what is new". It carries the number 18, which is right if the three intro slides replace slide 2 of that deck. The number is one line at the top of `outlook_slide.tex`.

## The four rows: what to say, and where each comes from

**1. Weighted Fuss–Catalan numbers.** "Konvalinka gives every node a weight that depends on its position in the tree and proves that the weighted count agrees with the plain one modulo a higher power of p. His proof moves branches with all permutations. It seems to need only what our rotations can do."
- Source: `references/README.md`, "Theorem 5": if b(0) ≡ 1 (mod q) and q^(n+1) divides the n-th difference of b, then C(b) ≡ C (mod p^(ξ+k)). His ξ is our t. **The slide leaves out the two conditions on the weight b.**
- Status in the ledger: claim C9, grade "computed". `experiments/E002_extensions`: six values of q, four weight functions each, no failure. No written proof. `talk/QA.md`, question 38: "this is not signed".
- This session did not rerun E002 and did not read Konvalinka's paper; the formula is the team's reading of it.

**2. Other statistics.** "A rotation does not change the depth of any node. So fix how many nodes sit at each depth: the number of such trees is this product of binomial coefficients, and it is still divisible by p^t. The same holds for the height and for anything else that rotations preserve."
- Source: claim C10; `FINDINGS.md`, row 7; `experiments/E007_refinements` (height, level profile and three more statistics).
- It is a two-line consequence of "every class has p^d trees, and d ≥ t". It is not in the paper yet.
- Checked here: `check_outlook.py`, 2a (the product counts the trees, by listing them) and 2b (26697 profiles for q = 2, 3, 4, 5, 8, 9; p^t divides every product; for 111 of them the power is exactly t).

**3. The next digit.** "The number of trees is the sum of p^d over the classes. So after dividing by p^t, the remainder modulo p² needs the number of classes with d = t and with d = t + 1. We know the first only modulo p."
- Source: `talk/QA.md`, question 40 ("we have data but no formula"); `FINDINGS.md`: "Residues modulo p²: data only".
- The formula on the slide is the class sum read modulo p², nothing more. To evaluate it one needs N_t modulo p² and N_(t+1) modulo p. The theorem gives N_t modulo p only.
- Checked here: 3a to 3c, for p = q = 2 (n ≤ 11), 3 (n ≤ 7), 5 (n ≤ 4). Example to have ready: 132 binary trees with n = 6, t = 2, classes N_2 = 3, N_3 = 3, N_4 = 4, N_5 = 1; indeed 132 = 3·4 + 3·8 + 4·16 + 1·32, and 132/4 = 33 ≡ 3 + 2·3 (mod 4).

**4. q not a prime power.** "Our first step turns a q-ary node into k levels of p-ary nodes. That needs q to be a power of p. For q = 6 we have not looked."
- Source: `talk/QA.md`, question 37; `FINDINGS.md`: "q not a prime power: not explored". By the team's reading of Konvalinka's paper (section 4), the conclusion of his weighted theorem fails for q = 6.
- The slide lists 6, 10, 12 only as the first numbers that are not prime powers.

**The grey line at the bottom.** The last sentence of the problem statement names "weighted Fuss–Catalan numbers" and "a multidimensional generalisation (or ones related to other statistics)" as a further direction. Rows 1 and 2 are those.

## Left off the slide on purpose

- **Lean.** `talk/QA.md`, question 46, still says that the next step is to extend the formal check to the residue. `lean/README.md` at 240176c says that Lean has checked the valuation and the residue. So this is no longer future work; it was left off, and question 46 needs an update (`PROPOSALS.md`, entry 9).
- **The human check.** The honest first item is not mathematics: the proofs are still under line-by-line human review (slide 15 of the team's deck says so). Say it aloud if asked what comes first.
- **A bijection** between labelled cyclic p-ary trees and permutations made of p-cycles, which would turn the count of the smallest classes for q = p into a bijective statement: holds in every tested case (`talk/QA.md`, question 34; `FINDINGS.md`). A good fifth row if there is room; left off to keep four.
- **The literature question** (is the rotation argument new for odd primes?) is for experts, not for a slide of plans.

## Not checked

- Row 1, as said above.
- Nothing here is a claim that any of the four will work. Rows 1 and 2 hold in every case computed; row 3 is an identity with an unknown in it; row 4 is a question.
- No person has read this slide.

## Build

```
python3 check_outlook.py > check_outlook_output.txt
latexmk -pdf outlook_slide.tex
```
