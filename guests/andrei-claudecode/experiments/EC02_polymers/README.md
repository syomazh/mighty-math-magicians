# EC02 — branched polymers: a hyperbranched molecule is a rooted tree, and class sizes are odds

- **Date:** 2026-11-14, by Claude Fable 5.2 (AI) in a second Claude Code session working with a team member. **Not the orchestrator; not human-reviewed.** Guest folder `guests/andrei-claudecode/`; moved here unchanged from `experiments/EC02_polymers/` of a local clone (local commit 6789468, never pushed), except for the paths in this file.
- **Belongs to:** `guests/andrei-claudecode/notes/2026-11-14_polymers_deep_dive.md`.
- **Folder name:** `EC02`, outside the orchestrator's `E0xx` numbering on purpose.

## Goal

Test, from a chemical model with monomers and bonds and no trees built in, that (a) the Fuss–Catalan number counts the molecules that n monomers of type AB_(f−1) can form, and (b) in the ideal one-pot reaction the class size p^d of the main proof is the relative abundance of an isomer.

## Hypothesis

A ring-free molecule of n monomers AB_(f−1) is a rooted (f−1)-ary tree with n nodes: the unit with the free A is the root, a reacted B is an edge, a free B is a leaf. Under equal reactivity all bond patterns are equally likely at every stage of the reaction.

## Method

`python3 guests/andrei-claudecode/experiments/EC02_polymers/run.py` from the repository root; `output.txt` is its output after a two-line header (standard library only; about three minutes, most of it the brute force of Part A; system Python 3.13.7 because `uv` is not installed on this machine). The simulation of Part C uses a fixed seed (137).

## Results (17 checks, all pass)

| Part | Statement | Result |
|---|---|---|
| A1 | By listing bond patterns of n labelled monomers with labelled B groups (f = 3, n ≤ 6; f = 4, 5, n ≤ 5; f = 6, n ≤ 4): the patterns that give one ring-free molecule number n! × FussCatalan(f−1, n), and each has one free A and (f−2)n + 1 free B. | pass |
| B1–B3 | The one-pot reaction "a free A meets a free B of another molecule, all such pairs equally likely", followed through every history for f = 3, n = 5 and f = 4, n = 4: the number of possible next bonds after j bonds is (n−j−1)·((f−1)n−j) whatever the state; so all bond patterns with j bonds are equally likely; among the final n-mers an isomer has probability (f−1)^d/FussCatalan. For f = 4, n = 4 the five isomers have probabilities 27/55, 9/55, 9/55, 9/55, 1/55. | pass |
| C1 | Simulation, 10^6 monomers AB2, 80% of the A groups reacted: 200,000 molecules; their sizes follow molecules × Catalan(n) × α^(n−1)(1−α)^(n+1) with α = 0.4 (chi-square 16.4 on 12 degrees of freedom). | pass |
| C2 | In the same run the isomers among the n-mers, n = 3..7, occur in proportion to 2^d (chi-square 0.1, 0.1, 9.5, 9.7, 14.1 on 1, 2, 5, 10, 22 degrees of freedom). Perfect dendrons: 4157 of 20,678 trimers (expected 1 in 5); 8 of 5835 heptamers (expected 13.6, 1 in 429). | pass |
| C3 | Degree of branching 2D/(2D + L) of the run: 0.4008; predicted α = 0.4000 (half the conversion of A). | pass |
| D1 | Σ_n FussCatalan(q, n)·α^(n−1)(1−α)^((q−1)n+1) = 1 for α below 1/q (q = 2..5). | pass |
| D2 | For f = 3..8: the largest value of α(1−α)^(f−2), reached at Flory's gel point α = 1/(f−1), equals (f−2)^(f−2)/(f−1)^(f−1), the radius of convergence of the Fuss–Catalan series for q = f − 1 (compared with the ratio of consecutive coefficients at n = 3000). | pass |
| D3 | Stockmayer's factor (fn−n)!/(n!(fn−2n+2)!) = FussCatalan(f−1, n)/((f−2)n+2), f = 3..7, n < 40 (the relation already in E012, part L). | pass |
| E1 | Degree of branching averaged over all plane binary trees with n nodes: 0.385, 0.448, 0.475, 0.4925, 0.4996 for n = 7, 15, 31, 100, 2000: it tends to 1/2. | pass |
| E2 | AB3 at full conversion, each B reacted with probability 1/3: (2D + sD)/((2/3)(3D + 2sD + L)) = 4/9. | pass |
| F1–F2 | For AB2: the power of 2 in Catalan(n) is log2 of the weight of the lightest isomer; the perfect dendron exists for n = 1, 3, 7, 15, 31, 63 and has weight 1 of Catalan(n) (1 in 5, 429, 9,694,845, 14,544,636,039,226,909, …); for n = 3, 7, 15 all isomer weights add up to Catalan(n). | pass |

## Analysis

- A1 and B are independent of the team's tree code: molecules are bond patterns, and the tree appears only when a finished molecule is classified.
- B1 is the whole reason for uniformity: every history has the same probability, and a pattern with j bonds has j! histories. Five lines; proved in the note.
- C is one run with one seed. It illustrates B; it proves nothing. With 22 degrees of freedom and an expected count of 13.6 the heptamer test is weak.
- E2 uses a formula for the degree of branching of AB3 polymers written from memory. That it gives the published 0.44 supports both the formula and the model, but the definition should be read in Hölter–Burgath–Frey before it is quoted.

## Next steps

None planned.
