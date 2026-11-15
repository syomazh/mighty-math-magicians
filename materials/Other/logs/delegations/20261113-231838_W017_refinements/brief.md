# W017 — Refinements by rotation-invariant statistics, and what happens when q is not a prime power

Read first: `CLAIMS.md` (C1, C2, C10, C11), `notes/briefing_grad_student/briefing.tex`, `notes/2026-11-13_new_ideas.md` (Idea 6), `experiments/E000_first_sanity_check/check.py` (you may reuse the class `Orbits`).

Write under `experiments/E007_refinements/`: `run.py` (first line a comment naming your model), `output.txt` (under 400 lines), `README.md` (Goal, Hypothesis, Method, Results, Analysis, Next steps). Run with `uv run python`. Report failures verbatim; label patterns as conjectures.

## Part A — Refinements (q = p^k)

Rotations of the p-ary refinement preserve many statistics of a q-ary tree. If claims C1 and C2 hold, then for every statistic σ constant on rotation classes and every value v, the number of q-ary trees with n nodes and σ = v is divisible by p^t, and its quotient by p^t is congruent mod p to the number of minimal classes with σ = v.

For (p,k) in {(2,1), (3,1), (5,1), (2,2), (3,2)} and n as large as feasible, and for each of these statistics:

1. height of the q-ary tree;
2. level profile (number of nodes at each q-ary depth);
3. number of nodes with exactly j non-empty branches, for each j (for q = 2: number of nodes with 0, 1, 2 children);
4. number of leaves (empty branches) at each depth;
5. the number of nodes all of whose branches are empty (the Narayana-type statistic);

do the following: (i) confirm the statistic is constant on rotation classes (by enumeration for small n); (ii) confirm divisibility of every refined count by p^t; (iii) list which values v are "tight" (valuation exactly t) and the residues; (iv) where a closed formula for the refined count is classical (for example ∏ binom(q·n_i, n_(i+1)) for level profiles), check it and restate the divisibility as an arithmetic statement; (v) look for a clean description of the tight values in terms of the base-p digits of m = (q−1)n+1, and state it as a conjecture with the supporting range.

Then pick the two cleanest resulting statements and write each as a precise conjecture/corollary with a three-line proof sketch from C1, C2 and the skeleton description of minimal classes.

## Part B — q not a prime power

Let q be arbitrary and p a prime dividing q (try q = 6 with p = 2 and p = 3; q = 10 with p = 2 and 5; q = 12 with p = 2 and 3; and q = 3, 5, 6, 7 with p = 2 where p need not divide q). At each q-ary node act with a Sylow p-subgroup of S_q: write q in base p, split the q branches left to right into blocks of sizes p^i according to the digits, and act on each block of size p^i by the rotation group of a complete p-ary tree of height i (blocks are not exchanged). Classes then have p-power size.

Compute, for n as large as feasible: the minimum exponent d_min over classes, the number N_min of classes attaining it, the true v_p(C_n^(q)) (from the binomial formula), and compare. Questions: Is d_min = v_p(C_n^(q)) always, sometimes, never? When it is, is N_min prime to p? Is there a formula for d_min in terms of digits? Report tables and state honest conjectures. This is exploratory: negative results are useful.

Work in short steps and save often. Touch only files under `experiments/E007_refinements/`.
