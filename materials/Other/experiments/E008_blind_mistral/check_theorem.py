# Written by mistralai/mistral-large-4-0 (worker W018, blind proof search) on 2026-11-13.
"""Sanity check: v_p(C_n^(q)) == (s_p((q-1)n+1) - 1)/(p-1) for q = p^k,
across many (p, k, n). Uses exact integer arithmetic only."""
from common import v_p, s_p, fuss_catalan

PRIMES = [2, 3, 5, 7, 11]
N_MAX = 300
bad = 0
checked = 0
for p in PRIMES:
    for k in (1, 2, 3):
        q = p ** k
        for n in range(1, N_MAX + 1):
            m = (q - 1) * n + 1
            lhs = v_p(fuss_catalan(n, q), p)
            rhs_num = s_p(m, p) - 1
            assert rhs_num % (p - 1) == 0, (p, k, n, m)
            rhs = rhs_num // (p - 1)
            checked += 1
            if lhs != rhs:
                bad += 1
                print(f"MISMATCH p={p} k={k} q={q} n={n} m={m} v_p={lhs} formula={rhs}")
print(f"checked {checked} cases, mismatches: {bad}")
