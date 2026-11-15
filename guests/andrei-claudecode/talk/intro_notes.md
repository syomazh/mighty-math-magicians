# The mathematical introduction: three slides

Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code, started by Andrei, 2026-11-14 at about 21:30 PT; second version and three changes to the last slide before 22:03 PT. Not human-reviewed.
The outline is Andrei's. The wording of the slides, the pictures and the notes below are AI-written.

The first version had four crowded slides. Andrei asked for fewer words, Catalan and Fuss–Catalan numbers side by side, and no picture of the twelve ternary trees. This is that version: the slides carry pictures, formulas and a few labels, and the speaker says the rest.

Files: `intro_slides.tex` and `intro_slides.pdf` (three pages, 16:9), `make_intro.py` (draws the trees and checks the numbers), `intro_trees.tex` (written by the script), `make_intro_output.txt` (9 checks, all pass).

## Where the slides go

They are made to look like the 16-slide deck in `talk/` and to stand between its title slide and its slide 3 ("The idea"). They carry the numbers 2 to 4; the first number is one line at the top of `intro_slides.tex`.

**They overlap slide 2 of that deck** ("How often does p divide the tree count?"), which states the problem with the formula on it. Two ways out, for the team to choose:

- these three slides replace it, and the residue (the second half of that slide) moves to the slide where it is proved; or
- that slide follows these three as "the precise statement".

The deck in `talk/` is a PDF of images. Its source is not in the repository, so the pages cannot be edited into it here. They can be put in front of it as PDF pages, or retyped in the tool it was made with.

## What to say (about three minutes)

The slides leave these things to the speaker. Each is one sentence.

**Slide 2, the two families.**
- Left: "You know the Catalan numbers. For us they count binary trees: every node has a left and a right child, or none."
- "We count the nodes that have children, the black dots. With three of them there are five trees." The red 5 in the row of values is this picture.
- Right: "Now give every node q children instead of two. The number of such trees is the Fuss–Catalan number. Here q is 3, and with two black dots there are three trees." The red 3 is this picture.
- "For q = 2 these are the Catalan numbers again." The slide does not say this.
- "There is a formula for the right side too. It comes in a minute."
- One fact for the next slide, also not on this one: "a tree with n black dots has (q − 1)n + 1 leaves, because every black dot turns one leaf into q." Count them on the pictures: 4 leaves on the left, 5 on the right.

**Slide 3, the problem.**
- "Take a prime p and let q be a power of p. How many times does p divide the number of trees?"
- "The answer is strange. Count the leaves, write that number in base p, add up the digits."
- Read the three rows. First: the five binary trees have 4 leaves, 100 in base 2, digit sum 1, so the power is 0, and 5 is odd. Second: the three ternary trees have 5 leaves, 12 in base 3, digit sum 3, so the power is (3 − 1)/2 = 1, and there are 3 of them. Third: 17 leaves, 122 in base 3, digit sum 5, power 2, and 43263 is 9 times 4807.
- For Catalan numbers the formula says: C_n is odd exactly when n + 1 is a power of two. Worth one sentence.
- Close the slide with the question: "Why would the digits of the number of leaves know anything about the trees?"

**Slide 4, the formula.** One line of mathematics: the formula, an arrow marked "Legendre's formula" and "Konvalinka 2007", and the statement. Under a rule: the problem, and "Our proof does not use the formula". (Two earlier versions gave the known proof more room, first as two boxes and then as three written-out lines; Andrei cut it down: the old proof is background, not the subject.)
- "Here is the formula for the number of trees." For q = 2 it is the Catalan formula of slide 2.
- "The known proof starts from it: write it with factorials, apply Legendre's formula for the power of p in a factorial, and the answer drops out in three lines." One sentence is enough.
- "It is correct. But the trees have disappeared, and with them any reason why the leaves matter."
- "The problem asks for a proof from the symmetries of the trees, without factorial valuations. From here on we do not use this formula. We only look at the trees."

The three lines, in case someone asks. With m = (q − 1)n + 1 the formula is (qn)!/(n!·m!). Legendre's formula says that the power of p in N! is (N − s_p(N))/(p − 1). So the power of p in the number of trees is [(qn − n − m) − s_p(qn) + s_p(n) + s_p(m)]/(p − 1). Here qn − n − m = −1, and s_p(qn) = s_p(n) because multiplying by q = p^k only appends zeros. What is left is (s_p(m) − 1)/(p − 1).

## Four things to get right when asked

1. **"The known proof" is not the only earlier work on trees.** Konvalinka's paper also has an argument on the trees, with all permutations of the branches. It proves that p^t divides the number, not that the power is exact (the problem statement says this, and so does slide 3 of the team's deck). Do not say that nobody looked at the trees before.
2. **For p = 2 an exact proof from trees exists.** Deutsch and Sagan (2006) prove the Catalan case by an orbit argument, with exactness (`references/README.md`, entry 2 and the changes listed under it; `paper/main.tex`, introduction). What is new is every odd prime and the prime powers. Do not present the Catalan fact as ours.
3. **"We do not use the formula"** is the statement of `paper/main.tex`: the binomial expression is used only to recognise the number of trees as the Fuss–Catalan number, for numerical values, and in one separately marked corollary (the exact count of the smallest classes for q = p). It is not used in the proof of the theorem. The residue contains factorials of digits, which are smaller than p; no valuation of a factorial is taken.
4. **q must be a power of p.** For a prime that does not divide q the slide says nothing.

## Checked, and not checked

- Every number on the slides is checked by `make_intro.py` against tree counts that do not come from the formula: the two pictures are listed by the program (5 binary trees, 3 ternary trees), the two rows of values, the three examples of slide 3, and the statement of slide 3 for q = 2, 4, 8, 16, 3, 9, 5, 7 and n up to 14. It also checks that the formula with Legendre's formula gives the statement (the three lines above, which stand behind the arrow of slide 4, for q = 2, 4, 8, 3, 9, 5, 7 and n < 200).
- **The three lines are our own write-out of the proof by Legendre's formula.** The team's reference list says that Konvalinka's Proposition 2 is proved with that formula. This session did not have the paper and did not compare the lines with his text.
- No bibliographic data beyond "Konvalinka 2007" is on the slides. The full entry is number 1 in `references/README.md`.
- The fonts (EB Garamond for titles, IBM Plex Sans for text) and the colours were matched to the team's deck by eye and by sampling its pixels. They are close, not identical.
- No person has read these slides.

## Build

```
python3 make_intro.py > make_intro_output.txt
latexmk -pdf intro_slides.tex
```

Built here with TeX Live 2023 and the system Python 3.13.7. Everything on a slide is placed by hand, in centimetres from the top left corner of the page, so moving one thing does not move the rest.
