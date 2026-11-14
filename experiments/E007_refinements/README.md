# E007 — Refinements by statistics that rotations preserve

Written and run by Claude Fable 5.2 (orchestrator), 2026-11-13. A Kimi worker (W017) had started this and was stopped to save Open Math OS budget; none of its code is used. Part B of the original brief (q not a prime power) was not done. Not human-reviewed.

- **Goal.** The problem statement asks for generalisations "related to other statistics". If C1 and C2 hold, then for any statistic σ that is constant on rotation classes and any value v, the number of q-ary trees with n nodes and σ = v is divisible by p^t, and its quotient by p^t is congruent mod p to the number of minimal classes with σ = v. Test this.
- **Statistics tested.** Height; level profile (nodes at each depth); degree vector (number of nodes with j non-empty branches, for each j); leaves by depth; number of childless nodes (all branches empty).
- **Method.** `run.py` enumerates every q-ary tree explicitly, computes rotation classes on the p-ary refinement, and checks for each statistic: (i) constant on classes, (ii) every refined count divisible by p^t, (iii) the residue rule. Run: `uv run python experiments/E007_refinements/run.py`.
- **Ranges.** q = 2 (n ≤ 9), q = 3 (n ≤ 6), q = 5 (n ≤ 4), q = 4 (n ≤ 5), q = 9 (n ≤ 3), q = 8 (n ≤ 3).
- **Results.** `output.txt`. **All checks pass** for all five statistics in all cases: 0 failures.
- **Analysis.**
  - All five statistics are constant on rotation classes, as expected, including for k > 1.
  - Divisibility by p^t survives every refinement tested. So, for example: *the number of binary trees with n nodes and height h is divisible by 2^(s_2(n+1) − 1) for every h*, and the same for the number with exactly j childless nodes.
  - Which values are "tight" (valuation exactly t) is governed by the parity (mod p) of the number of minimal classes with that value. Example, binary n = 6: heights 3, 4, 5, 6 have 4, 40, 56, 32 trees; t = 2; only height 3 is tight, because two of the three minimal classes have height 4 and cancel modulo 2.
  - **Observation (conjecture, p = 2).** For the number of childless nodes the only tight value in every tested case is the largest possible one. For odd n = 2j − 1 that count is the Catalan number C_(j−1), and the statement becomes the self-similarity v_2(C_(j−1)) = v_2(C_(2j−1)), which is true because s_2(2j) = s_2(j).
- **Limits.** Small n only (explicit enumeration). The level-profile statistic was tested much further in E002 by its product formula.
- **Next steps.** State the general corollary in the paper after C1, C2, C3 are signed (it is a two-line consequence of the class-sum identity). Decide whether the childless-node statement is worth a slide.
