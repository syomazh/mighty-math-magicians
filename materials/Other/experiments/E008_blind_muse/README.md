# E008 — Blind Muse: valuation from trees without factorials

## Goal
Computational checks for three independent proof strategies for
v_p(C_n^{(q)}) = (s_p(m)-1)/(p-1), m=(q-1)n+1, q=p^k.

## Hypothesis
- Strategy A: orbit sizes under a p-group on q-ary trees have p-power size with exponent matching the digit sum; verified by enumeration for q=2,4.
- Strategy B: generating function G=x+G^q mod p is sparse (support at p-powers), leading to digit sums via carry counting; verified for all p≤5, q≤9.
- Strategy C: C_n^{(q)}=binom(qn,n)/m (cycle lemma) + Kummer's carry theorem gives the valuation; verified for all tested parameters.

## Method
`check_all.py`: general valuation formula, q-ary tree enumeration, orbit decomposition (brute-force for q=2, n≤6), functional equation G=x+G^q verification, Lucas-type checks, cycle-lemma integrality, valuation decomposition, Kummer verification, digit-sum identity.
`check_extra.py`: C_n mod p nonvanishing at p-powers, functional equation with sufficient terms, G mod p sparsity support.

## Results
All checks pass (no FAIL in output). See file headers for details.
Run: `uv run python experiments/E008_blind_muse/check_all.py`
     `uv run python experiments/E008_blind_muse/check_extra.py`

## Analysis
The valuation formula holds for all tested p,k,n. Orbit minima match predictions. G mod p sparsity and carry identities confirmed. No counterexample found.

## Next steps
Fill GAPs in the three strategies: complete the minimal-orbit induction (A), the zero-carry residue argument (B), and the elementary Kummer proof (C).

*Model: meta/muse-spark-open*
